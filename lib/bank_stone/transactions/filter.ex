defmodule BankStone.Transactions.Filter do
  @moduledoc """
    Module responsible to filter transactions
  """

  import Ecto.Query, warn: false
  alias BankStone.Repo
  alias BankStone.Transactions.Transaction

  @doc """
  Returns all transactions

  ## Examples

      iex> list_transactions()
      [%Transactions{}, ...]
  """
  def list_transactions, do: Repo.all(Transaction)

  @doc """
  Returns all transactions by year

  ## Examples

      iex> by_year(year)
      [%Transactions{}, ...]
  """
  def by_year(year) do
    year = String.to_integer(year)
    start_date = Date.from_erl!({year, 01, 01})
    end_date = Date.from_erl!({year, 12, 31})
    query = from t in Transaction, where: t.date >= ^start_date and t.date <= ^end_date
    Repo.all(query)
  end

  @doc """
  Returns all transactions by month

  ## Examples

      iex> by_month(year, month)
      [%Transactions{}, ...]
  """
  def by_month(year, month) do
    year = String.to_integer(year)
    month = String.to_integer(month)
    start_date = Date.from_erl!({year, month, 01})
    days_in_month = Date.days_in_month(start_date)
    end_date = Date.from_erl!({year, month, days_in_month})
    query = from t in Transaction, where: t.date >= ^start_date and t.date <= ^end_date
    Repo.all(query)
  end

  @doc """
  Returns all transactions by date

  ## Examples

      iex> by_day(date)
      [%Transactions{}, ...]
  """
  def by_day(date) do
    query = from t in Transaction, where: t.date == ^Date.from_iso8601!(date)
    Repo.all(query)
  end
end
