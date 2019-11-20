defmodule BankStone.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BankStone.Repo
  alias BankStone.Accounts.{Account, User}
  alias BankStone.Accounts.Operations
  alias BankStone.Email, as: EmailServer
  alias BankStone.Transactions

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User) |> Repo.preload(:accounts)
  end

  @doc """
  Returns the list of Accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single user.

  Raises `nil` if the User does not exist.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      nil

  """
  def get_user(id), do: Repo.get(User, id) |> Repo.preload(:accounts)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    case insert_user(attrs) do
      {:ok, user} ->
        Ecto.build_assoc(user, :accounts)
        |> Account.changeset()
        |> Repo.insert()

        {:ok, user |> Repo.preload(:accounts)}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp insert_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Transfer value to other account 

  ## Examples

      iex> transfer_value(user, %{field: new_value})
      {:ok, %Transaction{}}

      iex> transfer_value(user, %{field: bad_value})
      {:error, msg}

  """
  def transfer_value(transfer_data) do
    value = Map.get(transfer_data, :value) |> Decimal.new()
    operation_sub = Map.get(transfer_data, :from_account) |> Operations.perform(value, :sub)

    case operation_sub do
      {:ok, account_from} ->
        {:ok, account_to} = Map.get(transfer_data, :to_account) |> Operations.perform(value, :add)

        %{
          value: value,
          account_from: account_from.id,
          type: "transfer",
          account_to: account_to.id,
          date: Date.utc_today()
        }
        |> Transactions.insert_transaction()

      {:error, msg} ->
        {:error, msg}
    end
  end

  @doc """
  withdraw value to other account 

  ## Examples

      iex> withdraw(user, %{field: new_value})
      {:ok, %User{}}

      iex> withdraw(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def withdraw(withdraw_data) do
    value = Map.get(withdraw_data, :value) |> Decimal.new()
    operation_sub = Map.get(withdraw_data, :from_account) |> Operations.perform(value, :sub)

    case operation_sub do
      {:ok, operation} ->
        %{
          value: value,
          account_from: operation.id,
          type: "withdraw",
          account_to: nil,
          date: Date.utc_today()
        }
        |> Transactions.insert_transaction()

        operation = operation
        |> Repo.preload(:user)
        |> EmailServer.Email.withdraw_email(value)
        |> EmailServer.Mailer.deliver_now()

        IO.inspect operation

        operation_sub

      {:error, msg} ->
        {:error, msg}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Gets a single user to Authenticate
  ## Examples
      iex> authenticate(teste@teste.com, "1234")
      {:ok, user}
      iex> authenticate(teste@te.com, "1234")
      {:error, :invalid_credentials}
  """
  def authenticate(email, plain_text_password) do
    query = from u in User, where: u.email == ^email

    case Repo.one(query) do
      nil ->
        Comeonin.Argon2.dummy_checkpw()
        {:error, :not_found}

      user ->
        if Comeonin.Argon2.checkpw(plain_text_password, user.password_hash) do
          {:ok, user |> Repo.preload(:accounts)}
        else
          {:error, :unauthorized}
        end
    end
  end
end
