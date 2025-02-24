defmodule Payday.Repo do
  use Ecto.Repo,
    otp_app: :payday,
    adapter: Ecto.Adapters.Postgres
end
