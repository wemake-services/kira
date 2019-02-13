defmodule Kira.Repo do
  use Ecto.Repo,
    otp_app: :kira,
    adapter: Ecto.Adapters.Postgres
end
