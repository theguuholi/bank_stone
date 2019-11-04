defmodule BankStone.Repo do
  use Ecto.Repo,
    otp_app: :bank_stone,
    adapter: Ecto.Adapters.Postgres
end
