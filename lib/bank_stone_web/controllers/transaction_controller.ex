defmodule BankStoneWeb.TransactionController do
  use BankStoneWeb, :controller

  alias BankStone.Accounts
  alias BankStoneWeb.Auth.Guardian

  action_fallback BankStoneWeb.FallbackController

  def all(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    IO.inspect "all"
  end

  def year(conn, params) do
    IO.inspect params
    user = Guardian.Plug.current_resource(conn)
    IO.inspect "year"

  end

  def month(conn, params) do
    IO.inspect params

    user = Guardian.Plug.current_resource(conn)
    IO.inspect "month"

  end

  def day(conn, params) do
    IO.inspect params

    user = Guardian.Plug.current_resource(conn)

    IO.inspect "day"

  end

end
