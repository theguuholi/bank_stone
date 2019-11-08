defmodule BankStoneWeb.TransactionController do
  use BankStoneWeb, :controller

  alias BankStone.Transactions

  action_fallback BankStoneWeb.FallbackController

  def all(conn, _params) do
    render(conn, "show.json", transaction: Transactions.all())
  end

  def year(conn, %{"year" => year}) do
    render(conn, "show.json", transaction: Transactions.year(year))
  end

  def month(conn, %{"year" => year, "month" => month}) do
    render(conn, "show.json", transaction: Transactions.month(year, month))
  end

  def day(conn, %{"date" => date}) do
    render(conn, "show.json", transaction: Transactions.day(date))
  end
end
