defmodule BankStone.Transactions.Transaction do
  @moduledoc """
    The Main reaso of this module is to create account to user
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type Ecto.UUID
  schema "transactions" do
    field :value, :decimal
    field :account_from, :string
    field :account_to, :string
    field :type, :string
    field :date, :date

    timestamps()
  end

  @doc false
  def changeset(account, attrs \\ %{}) do
    account
    |> cast(attrs, [:value, :account_from, :type, :account_to, :date])
    |> validate_required([:value, :account_from, :type, :date])
  end
end
