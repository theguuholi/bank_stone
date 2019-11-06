defmodule BankStone.Accounts.Account do
  @moduledoc """
    The Main reaso of this module is to create account to user
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type Ecto.UUID
  schema "accounts" do
    field :balance, :decimal, default: 1000
    belongs_to :user, BankStone.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(account, attrs  \\ %{}) do
    account
    |> cast(attrs, [:balance])
    |> validate_required([:balance])
  end
end
