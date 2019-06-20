defmodule Gotham.MixProject do
  use Mix.Project

  def project do
    [
      app: :gotham,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Gotham.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.1"},
      {:joken, "~> 2.1"},
      {:httpoison, "~> 1.5"},
      {:mox, "~> 0.5.1"}
    ]
  end
end
