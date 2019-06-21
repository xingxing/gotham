defmodule Gotham.GCPClient do
  @imp Application.get_env(:gotham, :gcp_client_imp, Gotham.GCPClient.HTTPoison)

  @callback get_access_token(Gotham.scope()) :: {:ok, Gotham.token()}
  defdelegate get_access_token(scope), to: @imp
end
