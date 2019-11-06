defmodule BankStoneWeb.OperationView do
  use BankStoneWeb, :view

  def render("index.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json", as: :user)}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id
    }
  end
end
