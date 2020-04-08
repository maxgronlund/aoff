use Mix.Config

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

config :arc,
  storage: Arc.Storage.S3,
  virtual_host: true,
  # if using Amazon S3
  bucket: System.get_env("AOFF_AWS_S3_BUCKET")

config :ex_aws,
  access_key_id: System.get_env("AOFF_AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AOFF_AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AOFF_AWS_REGION"),
  s3: [
    scheme: "https://",
    host: "s3." <> System.get_env("AOFF_AWS_REGION") <> ".amazonaws.com",
    region: System.get_env("AOFF_AWS_REGION")
  ]
