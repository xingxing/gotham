defmodule Gotham do
  @moduledoc """
  Documentation for Gotham.
  """

  def get_account_name() do
    Process.get(__MODULE__) || Application.get_env(:gotham, :default_account) ||
      raise Gotham.MissingAccountName
  end

  def put_account_name(account_name) when is_atom(account_name) do
    Process.put(__MODULE__, account_name)
  end

  def put_account_name(_account_name), do: raise(ArgumentError, "account_name must be an atom")
end
