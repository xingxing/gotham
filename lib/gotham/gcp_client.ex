defmodule Gotham.GCPClient do
  @type scope :: binary
  @type token :: Gotham.Token.t()

  @imp Application.get_env(:gotham, :gcp_client_imp, Gotham.GCPClient.HTTPoison)

  @callback get_access_token(scope) :: {:ok, token}
  defdelegate get_access_token(scope), to: @imp
end
