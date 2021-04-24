defmodule ExpenseJar.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ExpenseJar.Repo,
      # Start the Telemetry supervisor
      ExpenseJarWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ExpenseJar.PubSub},
      # Start the Endpoint (http/https)
      ExpenseJarWeb.Endpoint
      # Start a worker by calling: ExpenseJar.Worker.start_link(arg)
      # {ExpenseJar.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExpenseJar.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ExpenseJarWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
