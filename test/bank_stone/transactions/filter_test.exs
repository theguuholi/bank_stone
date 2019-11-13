defmodule BankStone.Transactions.FilterTest do
  use BankStone.DataCase

  alias BankStone.Transactions
  alias BankStone.Transactions.Filter

  describe "test all filters" do
    def transactions_fixture do
      [
        %{
          value: "100",
          account_from: "123123",
          type: "transfer",
          account_to: "112112",
          date: ~D[2019-11-08]
        },
        %{
          value: "100",
          account_from: "123123",
          type: "withdraw",
          account_to: "112112",
          date: ~D[2019-11-08]
        },
        %{
          value: "100",
          account_from: "123123",
          type: "transfer",
          account_to: "112112",
          date: ~D[2019-11-07]
        },
        %{
          value: "100",
          account_from: "123123",
          type: "transfer",
          account_to: "112112",
          date: ~D[2019-11-17]
        },
        %{
          value: "100",
          account_from: "123123",
          type: "transfer",
          account_to: "112112",
          date: ~D[2019-10-07]
        },
        %{
          value: "100",
          account_from: "123123",
          type: "transfer",
          account_to: "112112",
          date: ~D[2018-10-07]
        }
      ]
      |> Enum.map(fn transaction -> Transactions.insert_transaction(transaction) end)
    end

    test "should return all transactions" do
      transactions_fixture()
      transactions = Filter.list_transactions()
      assert Enum.count(transactions) == 6
    end

    test "should return all transactions by year" do
      transactions_fixture()
      transactions = Filter.by_year("2019")
      assert Enum.count(transactions) == 5
    end

    test "should return all transactions by month" do
      transactions_fixture()
      transactions = Filter.by_month("2019", "10")
      assert Enum.count(transactions) == 1
    end

    test "should return all transactions by day" do
      transactions_fixture()
      transactions = Filter.by_day("2019-11-08")
      assert Enum.count(transactions) == 2
    end
  end
end
