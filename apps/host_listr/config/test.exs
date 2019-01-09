# Since configuration is shared in umbrella projects, this file
# should only configure the :host_listr application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :host_listr, HostListr.Repo,
  username: "postgres",
  password: "postgres",
  database: "host_listr_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
