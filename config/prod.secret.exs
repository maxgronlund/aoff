# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

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

# config :arc,
#   storage: Arc.Storage.S3, # or Arc.Storage.Local
#   bucket: {:system, System.get_env("AWS_S3_BUCKET")} # if using Amazon S3

# config :arc,
#   storage: Arc.Storage.S3,
#   bucket: {:system, "AWS_S3_BUCKET"},
#   access_key_id: {:system, "AWS_ACCESS_KEY_ID"},
#   secret_access_key: {:system, "AWS_SECRET_ACCESS_KEY"},
#   s3: [
#     scheme: {:system, "S3_SCHEME"} || "https://",
#     host: {:system, "S3_HOST"} || "s3.amazonaws.com",
#     region: {:system, "S3_REGION"} || "eu-west-1"
#   ]
# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :aoff_web, BEWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
