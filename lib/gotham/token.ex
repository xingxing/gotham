defmodule Gotham.Token do
  @moduledoc ~S"""
  Interface for retrieving access tokens, from either the `Goth.TokenStore`
  or the Google token API. The first request for a token will hit the API,
  but subsequent requests will retrieve the token from Goth's token store.

  Goth will automatically refresh access tokens in the background as necessary,
  10 seconds before they are to expire. After the initial synchronous request to
  retrieve an access token, your application should never have to wait for a
  token again.

  The first call to retrieve an access token for a particular scope blocks while
  it hits the API. Subsequent calls pull from the `Goth.TokenStore`,
  and should return immediately

      iex> Goth.Token.for_scope("https://www.googleapis.com/auth/pubsub")
      {:ok, %Goth.Token{token: "23984723",
                        type: "Bearer",
                        scope: "https://www.googleapis.com/auth/pubsub",
                        expires: 1453653825,
                        account: :default}}

  If the passed credentials contain multiple service account, you can change
  the first parametter to be {client_email, scopes} to specify which account
  to target.

      iex> Goth.Token.for_scope({"myaccount@project.iam.gserviceaccount.com", "https://www.googleapis.com/auth/pubsub"})
      {:ok, %Goth.Token{token: "23984723",
                        type: "Bearer",
                        scope: "https://www.googleapis.com/auth/pubsub",
                        expires: 1453653825,
                        account: "myaccount@project.iam.gserviceaccount.com"}}

  For using the token on subsequent requests to the Google API, just concatenate
  the `type` and `token` to create the authorization header. An example using
  [HTTPoison](https://hex.pm/packages/httpoison):

      {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/pubsub")
      HTTPoison.get(url, [{"Authorization", "#{token.type} #{token.token}"}])
  """

  alias Goth.TokenStore
  alias Goth.Client

  @type t :: %__MODULE__{
          access_token: String.t(),
          token_type: String.t(),
          scope: String.t(),
          expire_at: non_neg_integer,
          account_name: atom
        }

  defstruct [:access_token, :token_type, :scope, :expire_at, :account_name]

  def from_response_json(
        %{
          access_token: access_token,
          expires_in: expires_in,
          token_type: token_type
        },
        scope
      ) do
    account_name = Gotham.get_account_name()

    %__MODULE__{
      access_token: access_token,
      expire_at: :os.system_time(:seconds) + expires_in,
      token_type: token_type,
      account_name: account_name,
      scope: scope
    }
  end
end
