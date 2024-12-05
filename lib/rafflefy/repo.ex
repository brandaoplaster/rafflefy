defmodule Rafflefy.Repo do
  use Ecto.Repo,
    otp_app: :rafflefy,
    adapter: Ecto.Adapters.Postgres
end
