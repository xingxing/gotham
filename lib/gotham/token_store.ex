defmodule Gotham.TokenStore do
  @moduledoc """
  The `Goth.TokenStore` is a simple `GenServer` that manages storage and retrieval
  of tokens `Goth.Token`. When adding to the token store, it also queues tokens
  for a refresh before they expire: ten seconds before the token is set to expire,
  the `TokenStore` will call the API to get a new token and replace the expired
  token in the store.
  """

  use GenServer
  alias Gotham.{Token, GCPClient}

  # APIs

  def start_link(account_name: account_name, keyfile_content: _) do
    GenServer.start_link(
      __MODULE__,
      %{account_name: account_name},
      name: worker_name(account_name)
    )
  end

  def for_scope(scope) do
    account_name = Gotham.get_account_name()

    account_name
    |> worker_name
    |> GenServer.call({:fetch, scope})
  end

  def request(scope) do
    scope |> GCPClient.get_access_token()
  end

  def store(%Token{account_name: account_name, scope: scope} = token) do
    account_name
    |> worker_name
    |> GenServer.call({:store, token})
  end

  def refresh(%{account_name: account_name} = original_token) do
    account_name
    |> worker_name
    |> GenServer.call({:refresh, original_token})
  end

  # Callbacks

  def init(state) do
    Gotham.put_account_name(state.account_name)
    {:ok, state}
  end

  def handle_call({:fetch, scope}, _from, state) do
    with :error <- Map.fetch(state, scope),
         {:ok, token} <- GCPClient.get_access_token(scope),
         {:ok, new_state} <- put_token(state, token),
         {:ok, _pid} <- queue_for_refresh(token) do
      {:reply, token, new_state}
    else
      token ->
        {:reply, token, state}
    end
  end

  def handle_call({:store, token}, _from, state) do
    new_state = put_token(state, token)
    {:reply, new_state, new_state}
  end

  def handle_call({:refresh, %{scope: scope}}, _from, state) do
    new_token = scope |> GCPClient.get_access_token()
    {:ok, new_state} = state |> put_token(new_token)
    {:reply, new_token, new_state}
  end

  defp put_token(state, token) do
    {:ok, Map.put(state, token.scope, token)}
  end

  defp queue_for_refresh(%{expire_at: expire_at, account_name: acount_name, scope: scope} = token) do
    {:ok, pid} = Task.Supervisor.start_link(name: task_supervisor_name(acount_name, scope))

    Task.Supervisor.async(pid, fn ->
      refresh_loop(token)
    end)

    {:ok, pid}
  end

  defp refresh_loop(%{expire_at: expire_at} = token) do
    diff = expire_at - :os.system_time(:seconds)

    if diff <= 10 do
      __MODULE__.refresh(token)
    else
      Process.sleep(diff * 1_000)
      refresh_loop(token)
    end
  end

  defp worker_name(account_name) do
    :"gotham_token_store_for_#{account_name}"
  end

  defp task_supervisor_name(account_name, scope) do
    scope_suffix = scope |> String.split("/") |> List.last()
    account_name = Gotham.get_account_name() |> IO.inspect()
    :"gotham_token_store_for_#{account_name}_#{scope_suffix}"
  end
end
