defmodule Btm.Repo do
  use Ecto.Repo,
    otp_app: :btm,
    adapter: Ecto.Adapters.Postgres
end
