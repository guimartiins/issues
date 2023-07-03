defmodule Issues.MixProject do
  use Mix.Project

  def project do
    [
      app: :issues,
      escript: escript_config(),
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      name: "Issues",
      source_url: "https://github.com/guimartiins/issues"
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 2.0"}
    ]
  end

  defp escript_config do
    [main_module: Issues.CLI]
  end
end
