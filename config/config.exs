# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :expense_jar,
  ecto_repos: [ExpenseJar.Repo]

# Configures the endpoint
config :expense_jar, ExpenseJarWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "832bsuXn+npiNNNNm4QlENEZA9dfUObJLQriDZHTlVn+ZXsJ/UvzMDoh4FCaVigC",
  render_errors: [view: ExpenseJarWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ExpenseJar.PubSub,
  live_view: [signing_salt: "AJ8BF7bz"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Uberauth
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

config :money,
  default_currency: :EUR,
  separator: ".",
  delimiter: ",",
  symbol: false,
  symbol_on_right: false,
  symbol_space: false,
  fractional_unit: true,
  strip_insignificant_zeros: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
