defmodule BankStoneWeb.OperationControllerTest do
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

  describe "Operations between acocunts" do
    test "should transfer a value to other account", %{conn: conn} do
      user = fixture(:user)
      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = get(conn, Routes.user_path(conn, :index))
      assert Enum.count(json_response(conn, 200)["data"]) == 1
    end
  end
end
