defmodule BankStoneWeb.TransactionView do
  use BankStoneWeb, :view

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, __MODULE__, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{total: transaction.total, transactions: transaction.transactions}
  end
end
