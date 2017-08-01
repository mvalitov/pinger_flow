defmodule Pinger.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @max_importers Application.get_env(:pinger, :max_importers)
  @max_pingers Application.get_env(:pinger, :max_pingers)
  @max_savers Application.get_env(:pinger, :max_savers)

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised

    children = [
        supervisor(Pinger.Repo, []),
        worker(Pinger.Worker, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pinger.Supervisor]
    Supervisor.start_link(children, opts)
    # Supervisor.start_link(repo_sup, opts)
  end
end
