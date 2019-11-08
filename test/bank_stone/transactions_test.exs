defmodule BankStone.TransactionsTest do
  use BankStone.DataCase

  alias BankStone.Transactions

  describe "test all kins transactions" do
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

    test "should insert a transactions" do
      transaction = %{
        value: "100",
        account_from: "123123",
        type: "transfer",
        account_to: "112112",
        date: ~D[2017-10-07]
      }

      result = Transactions.insert_transaction(transaction)
      {:ok, transaction} = result
      assert Decimal.new("100") == transaction.value
    end

    test "should return all transactions" do
      transactions_fixture()
      transactions = Transactions.all()

      assert transactions.total == 600.0
      assert Enum.count(transactions.transactions) == 6
    end

    test "should return all transactions by year" do
      transactions_fixture()
      transactions = Transactions.year("2019")

      assert transactions.total == 500.0
      assert Enum.count(transactions.transactions) == 5
    end

    test "should return all transactions by month" do
      transactions_fixture()
      transactions = Transactions.month("2019", "10")
      assert transactions.total == 100.0
      assert Enum.count(transactions.transactions) == 1
    end

    test "should return all transactions by day" do
      transactions_fixture()
      transactions = Transactions.day("2019-11-08")
      assert transactions.total == 200.0
      assert Enum.count(transactions.transactions) == 2
    end
  end
end
