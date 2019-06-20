defmodule Gotham.GCPClient.HTTPoison do
  alias Gotham.{ProfileKeeper, Token}

  def get_access_token(scope) do
    with {:ok, profile} <- ProfileKeeper.get_profile(),
         {:ok, %{body: body}} <- get_access_token(scope, profile),
         {:ok, json} <-
           body
           |> Jason.decode(keys: :atoms),
         %{access_token: _, expires_in: _, token_type: _} <- json do
      {:ok, json |> Token.from_response_json(scope)}
    else
      %{error: error, error_description: error_description} = reason ->
        {:error, reason}
    end
  end

  def get_access_token(scope, %{token_source: :oauth_jwt} = profile) do
    with endpoint <- Application.get_env(:gotham, :endpoint, "https://www.googleapis.com"),
         url <- "#{endpoint}/oauth2/v4/token",
         {:ok, jwt} <- issue_jwt(scope, profile) do
      body =
        {:form,
         [
           grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
           assertion: jwt
         ]}

      headers = [{"Content-Type", "application/x-www-form-urlencoded"}]

      HTTPoison.post(url, body, headers)
    end
  end

  def issue_jwt(scope, %{private_key: private_key, client_email: client_email}) do
    signer = Joken.Signer.create("RS256", %{"pem" => private_key})
    iat = :os.system_time(:seconds)

    %{
      "sub" => client_email,
      "iss" => client_email,
      "scope" => scope,
      "aud" => "https://www.googleapis.com/oauth2/v4/token",
      "iat" => iat,
      "exp" => iat + 10
    }
    |> Joken.Signer.sign(signer)
  end
end
