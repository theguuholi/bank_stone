defmodule BankStoneWeb.OperationView do
  use BankStoneWeb, :view

  def render("index.json", %{operation: operation}) do
    %{data: render_one(operation, __MODULE__, "operation.json")}
  end

  def render("operation.json", %{operation: operation}) do
    %{message: operation}
  end
end
