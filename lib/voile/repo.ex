defmodule Voile.Repo do
  use Ecto.Repo,
    otp_app: :voile,
    adapter: Ecto.Adapters.Postgres
end
