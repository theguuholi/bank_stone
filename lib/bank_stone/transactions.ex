defmodule BankStone.Transactions do
  @moduledoc """
    Load All performed transactions
  """

  import Ecto.Query, warn: false
  alias BankStone.Repo
  alias BankStone.Transactions.Transaction

  @doc """
  Returns all transactions and total value

  ## Examples

      iex> all()
      %{total: 1000, transactions: [%User{}, ...]}
  """
  def all do
    list_transactions()
    |> create_payload()
  end

  @doc """
  Returns all transactions by year and total value

  ## Examples

      iex> all()
      %{total: 1000, transactions: [%User{}, ...]}
  """
  def year(year) do
    transactions =
      list_transactions()
      |> by_year(year)
      |> create_payload()
  end

  defp create_payload(transactions) do
    %{
      total: calculate_value(transactions),
      transactions: transactions
    }
  end

  def by_year(transactions, year),
    do: Enum.filter(transactions, &(&1.date.year == String.to_integer(year)))

  defp calculate_value(trasactions) do
    Enum.map(trasactions, fn t -> Decimal.to_float(t.value) end)
    |> Enum.sum()
  end

  def insert_transaction(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def list_transactions, do: Repo.all(Transaction)
end
