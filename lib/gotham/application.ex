defmodule Gotham.Application do
  use Application

  def start(_type, _args) do
    with boot_result <- Gotham.Supervisor.start_link(:ok),
         {:ok, _} <- boot_result do
      Gotham.Supervisor.load_profiles()
      boot_result
    end
  end
end
