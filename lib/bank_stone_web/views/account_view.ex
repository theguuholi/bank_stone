defmodule BankStoneWeb.AccountView do
  use BankStoneWeb, :view

  def render("index.json", %{accounts: accounts}) do
    %{data: render_many(accounts, __MODULE__, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{
      id: account.id,
      balance: account.balance
    }
  end
end
