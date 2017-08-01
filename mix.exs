defmodule Pinger.Mixfile do
    use Mix.Project

    def project do
        [app: :pinger,
        version: "0.1.0",
        elixir: "~> 1.4",
        build_embedded: Mix.env == :prod,
        start_permanent: Mix.env == :prod,
        deps: deps()]
    end

    # Configuration for the OTP application
    #
    # Type "mix help compile.app" for more information
    def application do
        # Specify extra applications you'll use from Erlang/Elixir
        [extra_applications: [:logger, :httpoison, :ecto, :postgrex, :ip2location],
        mod: {Pinger.Application, []}]
    end

    # Dependencies can be Hex packages:
    #
    #   {:my_dep, "~> 0.3.0"}
    #
    # Or git/path repositories:
    #
    #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    #
    # Type "mix help deps" for more examples and options
    defp deps do
        [{:gen_stage, "~> 0.11"},
        {:httpoison, "~> 0.12"},
        {:poison, "~> 3.1"},
        {:redis_unique_queue, "~> 0.1.4"},
        {:ecto, "~> 2.0"},
        {:postgrex, "~> 0.11"},
        {:ip2location, github: "nazipov/ip2location-elixir"},
        {:logger_file_backend, "~> 0.0.9"},
        {:flow, "~> 0.11"}]
    end
end
