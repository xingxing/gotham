defmodule Gotham.Supervisor do
  use DynamicSupervisor

  alias Gotham.Alfred

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def load_profiles() do
    :gotham
    |> Application.get_env(:accounts, [])
    |> Enum.each(fn {account_name, [file_path: file_path]} ->
      with {:ok, content} <- file_path |> File.read() do
        spec = {Alfred, account_name: account_name, keyfile_content: content}

        DynamicSupervisor.start_child(__MODULE__, spec)
      end
    end)
  end

  @impl true
  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
