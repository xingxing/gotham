defmodule Gotham.Token do
  alias Goth.TokenStore
  alias Goth.Client

  @type t :: %__MODULE__{
          project_id: String.t(),
          access_token: String.t(),
          token_type: String.t(),
          scope: String.t(),
          expire_at: non_neg_integer,
          account_name: atom
        }

  defstruct [:access_token, :token_type, :scope, :expire_at, :account_name, :project_id]

  def from_response_json(
        %{
          access_token: access_token,
          expires_in: expires_in,
          token_type: token_type
        },
        scope,
        project_id
      ) do
    account_name = Gotham.get_account_name()

    %__MODULE__{
      project_id: project_id,
      access_token: access_token,
      expire_at: :os.system_time(:seconds) + expires_in,
      token_type: token_type,
      account_name: account_name,
      scope: scope
    }
  end
end
