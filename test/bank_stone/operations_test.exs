defmodule BankStone.OperationsTest do
  use BankStone.DataCase

  alias BankStone.Repo

  describe "users" do
    alias BankStone.Accounts.Account
    alias BankStone.Accounts.Operations

    def account_fixture do
      {:ok, account} = Repo.insert(Account.changeset(%Account{}))
      account
    end

    test "perform/3 should decrease balance" do
      account = account_fixture()
      assert account.balance == 1000
      {:ok, account} = Operations.perform(account.id, Decimal.new("100"), :sub)
      assert account.balance == Decimal.new("900.00")
    end

    test "perform/3 should show message error" do
      account = account_fixture()
      assert account.balance == 1000
      error = Operations.perform(account.id, Decimal.new("1100"), :sub)
      assert error == {:error, "You can`t have negative balance"}
    end

    test "perform/3 should increase balance" do
      account = account_fixture()
      assert account.balance == 1000
      {:ok, account} = Operations.perform(account.id, Decimal.new("100"), :add)
      assert account.balance == Decimal.new("1100.00")
    end
  end
end
