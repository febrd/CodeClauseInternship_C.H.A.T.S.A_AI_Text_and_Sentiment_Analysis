defmodule FebrdBot.Repo do
  use Ecto.Repo,
    otp_app: :febrd_bot,
    adapter: Ecto.Adapters.Postgres
end
