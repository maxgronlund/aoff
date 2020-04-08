# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# By default, the umbrella project as well as each child
# application will require this configuration file, as
# configuration and dependencies are shared in an umbrella
# project. While one could configure all applications here,
# we prefer to keep the configuration of each individual
# child application in their own app, but all other
# dependencies, regardless if they belong to one or multiple
# apps, should be configured in the umbrella to avoid confusion.
import_config "../apps/*/config/config.exs"

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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
