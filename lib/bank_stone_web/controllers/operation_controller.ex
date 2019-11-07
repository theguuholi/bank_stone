defmodule BankStoneWeb.OperationController do
  use BankStoneWeb, :controller

  alias BankStone.Accounts
  alias BankStoneWeb.Auth.Guardian

  action_fallback BankStoneWeb.FallbackController

  def transfer(conn, %{"to_account_id" => to_account, "value" => value}) do
    user = Guardian.Plug.current_resource(conn)

    operation =
      %{from_account: user.accounts.id, to_account: to_account, value: value}
      |> Accounts.transfer_value()

    case operation do
      {:ok, account} ->
        render(conn, "index.json", operation: "Transfer to: #{account.id} Success")

      {:error, msg} ->
        {:error, :not_found, msg}
    end
  end

  def withdraw(conn, %{"value" => value}) do
    user = Guardian.Plug.current_resource(conn)

    operation =
      %{from_account: user.accounts.id, value: value}
      |> Accounts.withdraw()

    case operation do
      {:ok, _account} ->
        render(conn, "index.json", operation: "Withdraw Success")

      {:error, msg} ->
        {:error, :not_found, msg}
    end
  end
end
