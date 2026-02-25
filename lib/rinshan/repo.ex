defmodule Rinshan.Repo do
  use Ecto.Repo,
    otp_app: :rinshan,
    adapter: Ecto.Adapters.Postgres
end
