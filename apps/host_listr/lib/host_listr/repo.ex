defmodule HostListr.Repo do
  use Ecto.Repo,
    otp_app: :host_listr,
    adapter: Ecto.Adapters.Postgres
end
