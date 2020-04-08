# Since configuration is shared in umbrella projects, this file
# should only configure the :aoff_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

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
  pubsub: [name: AOFFWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :gettext, :default_locale, "da"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
