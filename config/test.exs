use Mix.Config

# Configure your database
config :bank_stone, BankStone.Repo,
  username: "${DB_USERNAME}",
  password: "${DB_PASSWORD}",
  database: "${DB_DATABASE_TEST}",
  hostname: "${DB_HOSTNAME}",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bank_stone, BankStoneWeb.Endpoint,
  http: [port: 4002],
  server: false

config :bank_stone, BankStone.Email.Mailer, adapter: Bamboo.TestAdapter

# Print only warnings and errors during test
config :logger, level: :warn
