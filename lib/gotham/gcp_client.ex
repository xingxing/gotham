defmodule Gotham.GCPClient do
  @type scope :: binary
  @type token :: binary

  alias Gotham.GCPClient.Goth

  @imp Application.get_env(:goth, :gcp_client, Goth)

  @callback get_access_token(scope) :: {:ok, token}
  defdelegate get_access_token(scope), to: @imp
end
