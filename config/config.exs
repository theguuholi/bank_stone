# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bank_stone,
  ecto_repos: [BankStone.Repo]

# Configures the endpoint
config :bank_stone, BankStoneWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("APP_KEY_SECRET"),
  render_errors: [view: BankStoneWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: BankStone.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :bank_stone, BankStone.Email.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server:  System.get_env("EMAIL_SMTP"),
  hostname: System.get_env("EMAIL_HOSTNAME"),
  port: System.get_env("EMAIL_PORT"),
  username: System.get_env("EMAIL_USERNAME"),
  password: System.get_env("EMAIL_PASSWORD"), 
  tls: :if_available,
  allowed_tls_versions: [:"tlsv1", :"tlsv1.1", :"tlsv1.2"],
  ssl: false,
  retries: 1
  
config :bank_stone, BankStoneWeb.Auth.Guardian,
  issuer: "bank_stone",
  secret_key: System.get_env("AUTH_GUARDIAN")

if Mix.env() == :test do
  config :junit_formatter,
    report_dir: "/tmp/bank-stone-test-results/exunit/"
end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
