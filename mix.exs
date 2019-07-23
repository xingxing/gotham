defmodule Gotham.MixProject do
  use Mix.Project

  def project do
    [
      app: :gotham,
      version: "0.1.4",
      elixir: "~> 1.6",
      description: description(),
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]

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
      {:mox, "~> 0.5.1", only: :test},
      {:ex_doc, "~> 0.18.0", only: :dev}
    ]
  end

  defp description() do
    "Google Cloud Platform authentication, supports multiple GCP service accounts"
  end

  defp package() do
    [
      # These are the default files included in the package
      files: ~w(lib  mix.exs README*  LICENSE*),
      maintainers: ["Wade Ying Xing"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/xingxing/gotham"}
    ]
  end

  defp get_version(init_version \\ "0.1.0") do
    case System.cmd("git", ["describe", "--abbrev=0"]) do
      {"", _} ->
        init_version

      {version, _} ->
        version
    end
  end
end
