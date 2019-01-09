# Since configuration is shared in umbrella projects, this file
# should only configure the :host_listr application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :host_listr, HostListr.Repo,
  username: "hostlistr",
  password: "NUCjyvyqIZXDbY",
  database: "host_listr_dev",
  hostname: "localhost",
  pool_size: 10
