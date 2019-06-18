defmodule Gotham.GCPClient.Goth do
  alias Gotham.Alfred

  def get_access_token(scope) do
    with {:ok, profile} <- Alfred.get_profile(), do: get_access_token(scope, profile)
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

  # defp handle_response(resp, opts)

  # defp handle_response({:ok, %{body: body, status_code: code}}, {account, scope}, sub)
  #      when code in 200..299,
  #      do: {:ok, Token.from_response_json({account, scope}, sub, body)}

  # defp handle_response({:ok, %{body: body}}, _scope, _sub),
  #   do: {:error, "Could not retrieve token, response: #{body}"}

  # defp handle_response(other, _scope, _sub), do: other
end
