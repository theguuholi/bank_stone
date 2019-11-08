defmodule BankStone.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :account_from, :string
      add :account_to, :string
      add :type, :string
      add :date, :date
      add :value, :decimal, precision: 10, scale: 2

      timestamps()
    end
  end
end
