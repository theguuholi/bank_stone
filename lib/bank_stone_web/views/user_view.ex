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
      role: user.role,
      account: %{
        id: user.accounts.id,
        balance: user.accounts.balance
      }
    }
  end

  def render("user_auth.json", %{user: user, token: token}) do
    %{
      id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      role: user.role,
      account: %{
        id: user.accounts.id,
        balance: user.accounts.balance
      },
      token: token
    }
  end
end
