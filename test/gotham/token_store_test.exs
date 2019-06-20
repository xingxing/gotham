defmodule Gotham.TokenStoreTest do
  alias Gotham.{Token, TokenStore}
  alias Gotham.GCPClient.Mox, as: GCPClient

  use ExUnit.Case, async: true

  import Mox

  setup :set_mox_global
  setup :verify_on_exit!

  @expire_at :os.system_time(:seconds) + 3600

  describe "for_scope/1" do
    test "when token for a specific scope hasn't been stored" do
      GCPClient
      |> expect(:get_access_token, fn "pubsub" ->
        {:ok,
         %Token{
           scope: "pubsub",
           expire_at: @expire_at,
           account_name: :account1,
           access_token: "token"
         }}
      end)

      assert TokenStore.for_scope("pubsub") == %Token{
               access_token: "token",
               account_name: :account1,
               expire_at: @expire_at,
               scope: "pubsub",
               token_type: nil
             }
    end

    test "when token for a specific scope has been stored" do
      token = %Token{
        access_token: "token",
        account_name: :account1,
        expire_at: 1,
        scope: "cloudsql",
        token_type: "Bare"
      }

      TokenStore.store(token)

      assert TokenStore.for_scope("cloudsql") == {:ok, token}
    end
  end
end
