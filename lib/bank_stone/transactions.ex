defmodule BankStone.Transactions do
  @moduledoc """
    Load All performed transactions
  """

  import Ecto.Query, warn: false

  alias BankStone.Repo
  alias BankStone.Transactions.Filter
  alias BankStone.Transactions.Transaction

  @doc """
  Returns all transactions and total value

  ## Examples

      iex> all()
      %{total: 1000, transactions: [%Transactions{}, ...]}
  """
  def all do
    Filter.list_transactions()
    |> create_payload()
  end

  @doc """
  Returns all transactions by year and total value

  ## Examples

      iex> year(year)
      %{total: 1000, transactions: [%Transactions{}, ...]}
  """
  def year(year) do
    Filter.by_year(year)
    |> create_payload()
  end

  @doc """
  Returns all transactions by month and total value

  ## Examples

      iex> month(year, month)
      %{total: 1000, transactions: [%Transactions{}, ...]}
  """
  def month(year, month) do
    Filter.by_month(year, month)
    |> create_payload()
  end

  @doc """
  Returns all transactions by date and total value

  ## Examples

      iex> day(year, month)
      %{total: 1000, transactions: [%Transactions{}, ...]}
  """
  def day(date) do
    Filter.by_day(date)
    |> create_payload()
  end

  defp create_payload(transactions) do
    %{
      total: calculate_value(transactions),
      transactions: transactions
    }
  end

  defp calculate_value(trasactions) do
    Enum.map(trasactions, fn t -> Decimal.to_float(t.value) end)
    |> Enum.sum()
  end

  @doc """
  Creates a Transaction.

  ## Examples

      iex> insert_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def insert_transaction(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end
end
