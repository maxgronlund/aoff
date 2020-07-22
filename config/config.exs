use Mix.Config

# Configure Mix tasks and generators
config :aoff,
  namespace: AOFF,
  ecto_repos: [AOFF.Repo]

# General application configuration
config :aoff_web,
  namespace: AOFFWeb,
  ecto_repos: [AOFF.Repo],
  generators: [context_app: :aoff, binary_id: true]

# Configures the endpoint
config :aoff_web, AOFFWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Uc830879o+fgFbSBJg54+TesvR7F8Rw/1AKFMw6koyGxYWGWqECDDMjkvijqSxgS",
  render_errors: [view: AOFFWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: AOFFWeb.PubSub,
  live_view: [signing_salt: "bxyFEm6N"]

config :gettext, :default_locale, "da"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Support for slime
config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine,
  # If you want to use LiveView
  slimleex: PhoenixSlime.LiveViewEngine

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :money,
  # this allows you to do Money.new(100)
  default_currency: :DKK,
  # change the default thousands separator for Money.to_string
  separator: ".",
  # change the default decimal delimeter for Money.to_string
  delimiter: ",",
  # don’t display the currency symbol in Money.to_string
  symbol: true,
  # position the symbol
  symbol_on_right: true,
  # add a space between symbol and number
  symbol_space: true,
  # display units after the delimeter
  fractional_unit: true,
  # don’t display the insignificant zeros or the delimeter
  strip_insignificant_zeros: false

config :ex_cldr,
  default_locale: "en",
  json_library: Jason

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

config :aoff_web,
  epay: [
    merchantnumber: System.get_env("EPAY_MERCHANT_NR"),
    endpoint: System.get_env("EPAY_ENDPOINT")
  ]

config :aoff_web,
  cpsms: [
    endpoint: System.get_env("CPSMS_ENDPOINT"),
    token: System.get_env("CPSMS_TOKEN")
  ]

config :airbrakex,
  project_key: System.get_env("AIRBRAKE_API_KEY"),
  project_id: System.get_env("AIRBRAKE_PROJECT_ID"),
  logger_level: :error,
  environment: Mix.env,
  ignore: [Phoenix.Router.NoRouteError]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
