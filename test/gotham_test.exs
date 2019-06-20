defmodule GothamTest do
  use ExUnit.Case

  describe("get_account_name/1") do
    test "when account name has been setted" do
      Process.put(Gotham, :account_a)
      assert Gotham.get_account_name() == :account_a
    end

    test "otherwise use default account name" do
      Application.put_env(:gotham, :default_account, :account_b)
      assert Gotham.get_account_name() == :account_b
    end

    test "raise an exception when can not get an acccount name" do
      Application.put_env(:gotham, :default_account, nil)

      assert_raise Gotham.MissingAccountName, "Can not fond account name", fn ->
        Gotham.get_account_name()
      end
    end
  end

  describe "put_account_name/1" do
    test "when account name is an atom" do
      assert Gotham.put_account_name(:account1)
      assert Process.get(Gotham) == :account1
    end

    test "when account name is not an atom" do
      assert_raise ArgumentError, "account_name must be an atom", fn ->
        Gotham.put_account_name("account_b")
      end
    end
  end
end
