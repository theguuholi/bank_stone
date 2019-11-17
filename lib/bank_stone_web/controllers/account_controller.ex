defmodule BankStoneWeb.AccountController do
  use BankStoneWeb, :controller

  alias BankStone.Accounts

  action_fallback BankStoneWeb.FallbackController

  def index(conn, _params) do
    render(conn, "index.json", accounts: Accounts.list_accounts())
  end
end
