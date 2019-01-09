# Since configuration is shared in umbrella projects, this file
# should only configure the :host_listr_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :host_listr_web,
  ecto_repos: [HostListr.Repo],
  generators: [context_app: :host_listr]

# Configures the endpoint
config :host_listr_web, HostListrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tzRGzJHua+TpwYbhOXkWCcfUFTtc+jNe0Fgvug5XdSwYfjBBDe6mFyH18cr8yzNE",
  render_errors: [view: HostListrWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HostListrWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
