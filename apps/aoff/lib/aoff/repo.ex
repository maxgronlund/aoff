defmodule AOFF.Repo do
  use Ecto.Repo,
    otp_app: :aoff,
    adapter: Ecto.Adapters.Postgres
end
