defmodule Simz5.Repo do
  use Ecto.Repo,
    otp_app: :simz5,
    adapter: Ecto.Adapters.Postgres
end
