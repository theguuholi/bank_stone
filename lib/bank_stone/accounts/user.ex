defmodule BankStone.Accounts.User do
  @moduledoc """
    The Main reaso of this module is to manipulate Account User
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  schema "users" do
    field :balance, :decimal, default: 1000
    field :email, :string, unique: true
    field :first_name, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :role, :string, default: "user"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :email,
      :first_name,
      :last_name,
      :password,
      :password_confirmation,
      :role
    ])
    |> validate_required([
      :email,
      :first_name,
      :last_name,
      :password,
      :password_confirmation,
      :role
    ])
    |> validate_format(:email, ~r/@/, message: "Invalid email format!")
    |> update_change(:email, &String.downcase(&1))
    |> validate_length(:password,
      min: 6,
      max: 100,
      message: "Password should have between 6 until 100 chars"
    )
    |> validate_confirmation(:password, message: "Password does not match")
    |> unique_constraint(:email, message: "There is an user with this email")
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end

  defp hash_password(changeset) do
    changeset
  end
end
