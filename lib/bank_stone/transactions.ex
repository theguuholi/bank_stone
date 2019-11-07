defmodule BankStone.Transactions do
  @moduledoc """
    Load All performed transactions
  """

  import Ecto.Query, warn: false
  alias BankStone.Repo

  @doc """
  Returns all transactions and total value

  ## Examples

      iex> all()
      %{total: 1000, transactions: [%User{}, ...]}
  """
  def all do
    transactions = [
      %{date: Date.utc_today(), from: 123_123, to: 123, type: "transfer", value: 500},
      %{date: Date.utc_today(), from: 123_123, to: 123, type: "transfer", value: 500},
      %{date: Date.utc_today(), from: 123_123, to: nil, type: "withdraw", value: 500}
    ]

    %{
      total: calculate_value(transactions),
      transactions: transactions
    }
  end

    @doc """
  Returns all transactions by year and total value

  ## Examples

      iex> all()
      %{total: 1000, transactions: [%User{}, ...]}
  """
  def year(year) do
    transactions = [
      %{date: Date.utc_today(), from: 123_123, to: 123, type: "transfer", value: 500},
      %{date: ~D[2018-10-07], from: 123_123, to: 123, type: "transfer", value: 500},
      %{date: Date.utc_today(), from: 123_123, to: nil, type: "withdraw", value: 500}
    ]
    |> by_year(year)

  
    %{
      total: calculate_value(transactions),
      transactions: transactions
    }
  end

  def by_year(transactions, year), do: Enum.filter(transactions, &(&1.date.year == String.to_integer(year)))


  defp calculate_value(trasactions) do
    Enum.map(trasactions, fn t -> t.value end) |> Enum.sum()
  end
end
