defmodule BankStoneWeb.Auth.ErrorHandler do
  @moduledoc """
    error handler for authentication
  """
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    IO.inspect to_string(type)

    body = Poison.encode!(%{error: to_string(type)})
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
