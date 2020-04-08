# Since configuration is shared in umbrella projects, this file
# should only configure the :aoff application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :aoff,
  namespace: AOFF,
  ecto_repos: [AOFF.Repo]

import_config "#{Mix.env()}.exs"
