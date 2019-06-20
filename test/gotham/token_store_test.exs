defmodule Gotham.TokenStoreTest do
  alias Gotham.TokenStore

  use ExUnit.Case

  describe "for_scope/1" do
    test "normal case" do
      assert TokenStore.for_scope("https://www.googleapis.com/auth/pubsub") == "1"
    end
  end
end
