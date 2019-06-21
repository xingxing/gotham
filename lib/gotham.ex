defmodule Gotham do
  @moduledoc """
  Documentation for Gotham.
  """
  alias Gotham.{TokenStore, ProfileKeeper}

  @type scope :: binary
  @type token :: Gotham.Token.t()

  @spec get_account_name() :: atom
  def get_account_name() do
    Process.get(__MODULE__) || Application.get_env(:gotham, :default_account) ||
      raise Gotham.MissingAccountName
  end

  @spec put_account_name(atom) :: {:ok, atom} | {:error, any()}
  def put_account_name(account_name) when is_atom(account_name) do
    if invalid_account_name?(account_name) do
      {:error, "invalid account_name"}
    else
      Process.put(__MODULE__, account_name)
      {:ok, account_name}
    end
  end

  def put_account_name(_account_name), do: raise(ArgumentError, "account_name must be an atom")

  def with_account_name(account_name, fun) do
    previous_account_name = Process.get(__MODULE__)

    with {:ok, account_name} <- put_account_name(account_name) do
      try do
        fun.()
      after
        if previous_account_name do
          put_account_name(previous_account_name)
        else
          Process.delete(Gotham)
        end
      end
    end
  end

  def invalid_account_name?(account_name) do
    account_name
    |> Gotham.Alfred.supervisor_name()
    |> Process.whereis()
    |> is_nil
  end

  @spec for_scope(scope) :: {:ok, token} | {:error, any()}
  defdelegate for_scope(scope), to: TokenStore

  @spec get_profile() :: {:ok, Map.t()}
  defdelegate get_profile(), to: ProfileKeeper
end
