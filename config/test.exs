use Mix.Config

query_args = ["SET search_path TO public", []]

# Configure your database
config :aoff, AOFF.Repo,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  database: "aoff_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  after_connect: {Postgrex, :query!, query_args}

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :aoff_web, AOFFWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# config/config.exs
config :aoff_web, AOFFWeb.Mailer,
  adapter: Bamboo.TestAdapter,
  api_key: System.get_env("AOFF_SEND_GRID_API_KEY"),
  email_from: System.get_env("AOFF_EMAIL_FROM")

config :aoff, :sms_api, AOFF.Test.SMSApi
