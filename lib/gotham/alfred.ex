defmodule Gotham.Alfred do
  @moduledoc ~S"""
  `Gotham.Alfred` is a `GenServer` that holds a service account profile.
  """

  use GenServer

  def start_link(account_name: account_name, keyfile_content: keyfile_content) do
    GenServer.start_link(__MODULE__, keyfile_content, name: worker_name(account_name))
  end

  def get_profile do
    with account_name <- Gotham.get_account_name() do
      GenServer.call(worker_name(account_name), {:get})
    end
  end

  ### callbacks
  def init(keyfile_content) do
    profile = keyfile_content |> decode_json!()
    {:ok, profile}
  end

  def handle_call({:get}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  defp decode_json!(json) do
    json
    |> Jason.decode!(keys: :atoms)
    |> set_token_source
  end

  defp set_token_source(map = %{private_key: _}) do
    Map.put(map, :token_source, :oauth_jwt)
  end

  defp set_token_source(map = %{refresh_token: _, client_id: _, client_secret: _}) do
    Map.put(map, :token_source, :oauth_refresh)
  end

  defp worker_name(account_name) do
    :"alfred_for_#{account_name}"
  end
end
