defmodule BankStone.Accounts.Operations do
  @moduledoc """
      This module is to simplify datas about manipulations
  """

  alias BankStone.Accounts.Account
  alias BankStone.Repo

  def perform(account_id, value, operation) do
    Repo.get(Account, account_id)
    |> perform_operation(value, operation)
  end

  defp perform_operation(account, value, :sub) do
    new_balance = Decimal.sub(account.balance, value)

    case Decimal.negative?(new_balance) do
      true -> {:error, "You can`t have negative balance"}
      false -> update_account(account, %{balance: new_balance})
    end
  end

  defp perform_operation(account, value, :add) do
    account
    |> update_account(%{balance: Decimal.add(account.balance, value)})
  end

  defp update_account(%Account{} = account, attrs) do
    Account.changeset(account, attrs)
    |> Repo.update()
  end
end
