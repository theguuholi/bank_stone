defmodule BankStoneWeb.AccountControllerTest do
  use BankStoneWeb.ConnCase

  alias BankStone.Accounts
  import BankStoneWeb.Auth.Guardian

  @create_attrs %{
    email: "some@email",
    first_name: "some first_name",
    last_name: "some last_name",
    password: "somepassword",
    password_confirmation: "somepassword"
  }

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "List Accounts" do
    test "should List Accounts", %{conn: conn} do
      logged_user = fixture(:user)
      {:ok, token, _} = encode_and_sign(logged_user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = get(conn, Routes.account_path(conn, :index))
      result = json_response(conn, 200)["data"]
      assert 1 == result |> Enum.count()
    end
  end
end
