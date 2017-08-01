# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :pinger, Pinger.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "proxyz_development",
  username: "qwerty",
  password: "qwerty",
  hostname: "0.0.0.0",
  port: 6543

config :pinger, ecto_repos: [Pinger.Repo]

config :pinger,
  redis_host: "0.0.0.0",
  redis_port: 6379,
  stages: 10,
  max_demand: 5,
  min_demand: 0


database_file =
  [ __DIR__, "../data/IP2LOCATION-LITE-DB3.BIN/IP2LOCATION-LITE-DB3.BIN" ]
    |> Path.join()
    |> Path.expand()

config :ip2location,
  database: database_file,
  pool: [ size: 5, max_overflow: 10 ]

config :logger,
  backends: [{LoggerFileBackend, :debug},
             {LoggerFileBackend, :info},
             {LoggerFileBackend, :error}]

config :logger, :info,
  path:   [ __DIR__, "../logs/info.log" ]
      |> Path.join()
      |> Path.expand(),
  level: :info

config :logger, :error,
  path:   [ __DIR__, "../logs/error.log" ]
    |> Path.join()
    |> Path.expand(),
  level: :error

config :logger, :debug,
  path:   [ __DIR__, "../logs/debug.log" ]
    |> Path.join()
    |> Path.expand(),
  level: :debug
# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :genstage_example, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:genstage_example, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
