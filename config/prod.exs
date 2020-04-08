use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :aoff, BE.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "8")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :aoff_web, BEWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base

config :aoff_web,
  basic_auth: [
    username: System.get_env("BASIC_AUTH_USERNAME"),
    password: System.get_env("BASIC_AUTH_PASSWORD"),
    realm: System.get_env("BASIC_AUTH_REALM")
  ]

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
