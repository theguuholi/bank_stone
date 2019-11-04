defmodule BankStoneWeb.UserView do
  use BankStoneWeb, :view
  alias BankStoneWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      password: user.password,
      password_confirmation: user.password_confirmation,
      password_hash: user.password_hash,
      role: user.role,
      balance: user.balance
    }
  end
end
