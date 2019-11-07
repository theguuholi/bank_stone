defmodule BankStoneWeb.TransactionView do
  use BankStoneWeb, :view

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, __MODULE__, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    transaction_list =
      Enum.map(transaction.transactions, fn transaction ->
        %{
          date: transaction.date,
          account_from: transaction.account_from,
          account_to: transaction.account_to,
          type: transaction.type,
          value: transaction.value
        }
      end)

    %{total: transaction.total, transactions: transaction_list}
  end
end
