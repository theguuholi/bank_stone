defmodule BankStone.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :first_name, :string
      add :last_name, :string
      add :password, :string
      add :password_confirmation, :string
      add :password_hash, :string
      add :role, :string
      add :balance, :string

      timestamps()
    end
  end
end
