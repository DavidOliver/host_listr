# Since configuration is shared in umbrella projects, this file
# should only configure the :host_listr application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :host_listr,
  ecto_repos: [HostListr.Repo]

config :tesla,
  adapter: Tesla.Adapter.Hackney

import_config "#{Mix.env()}.exs"
