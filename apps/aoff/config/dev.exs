# Since configuration is shared in umbrella projects, this file
# should only configure the :aoff application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :aoff, AOFF.Repo,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  database: "aoff_dev",
  hostname: "localhost",
  pool_size: 10
