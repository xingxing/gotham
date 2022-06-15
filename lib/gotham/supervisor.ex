defmodule Gotham.Supervisor do
  use DynamicSupervisor

  alias Gotham.Alfred

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def load_profiles() do
    :gotham
    |> Application.get_env(:accounts, [])
    |> Enum.each(fn {account_name, opts} ->
      content = load_credentials(opts)
      spec = {Alfred, account_name: account_name, keyfile_content: content}
      DynamicSupervisor.start_child(__MODULE__, spec)
    end)
  end

  defp load_credentials(file_path: file_path) do
    File.read!(file_path)
  end

  defp load_credentials(content: content) do
    content
  end

  defp load_credentials(env_var: env_var) do
    System.get_env(env_var)
  end

  @impl true
  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
