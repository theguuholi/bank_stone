defmodule BankStoneWeb.TransactionController do
  use BankStoneWeb, :controller

  alias BankStone.Transactions

  action_fallback BankStoneWeb.FallbackController

  def all(conn, params) do
    render(conn, "show.json", transaction: Transactions.all())
  end

  def year(conn, %{"year" => year}) do
    render(conn, "show.json", transaction: Transactions.year(year))
  end

  def month(conn, params) do
  end

  def day(conn, params) do
  end
end
