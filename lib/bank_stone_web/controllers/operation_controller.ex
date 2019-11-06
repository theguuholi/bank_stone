defmodule BankStoneWeb.OperationController do
  use BankStoneWeb, :controller

  alias BankStone.Accounts
  alias BankStoneWeb.Auth.Guardian

  action_fallback BankStoneWeb.FallbackController

  def transfer(conn, %{"to_account_id" => to_account, "value" => value}) do
    user = Guardian.Plug.current_resource(conn)

    %{from_account: user.accounts.id, to_account: to_account, value: value}
    |> Accounts.transfer_value()

    render(conn, "index.json", user: user)
  end
end
