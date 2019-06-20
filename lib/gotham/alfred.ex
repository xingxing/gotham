defmodule Gotham.Alfred do
  @moduledoc ~S"""
  `Gotham.Alfred` is a `Supervisor` that supervises a set of work: profile_keeper and token_store .
  """

  use Supervisor

  import Supervisor.Spec

  alias Gotham.{ProfileKeeper, TokenStore}

  ### APIs

  def start_link(args) do
    Supervisor.start_link(__MODULE__, [args], name: supervisor_name(args[:account_name]))
  end

  ### Callbacks
  def init(args) do
    children = [
      worker(ProfileKeeper, args),
      worker(TokenStore, args)
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end

  def supervisor_name(account_name), do: :"gotham_alfred_for_#{account_name}"
end
