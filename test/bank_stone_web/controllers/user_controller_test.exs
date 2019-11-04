defmodule BankStoneWeb.UserControllerTest do
  use BankStoneWeb.ConnCase

  alias BankStone.Accounts
  alias BankStone.Accounts.User

  @create_attrs %{
    email: "some@email",
    first_name: "some first_name",
    last_name: "some last_name",
    password: "somepassword",
    password_confirmation: "somepassword"
  }
  @update_attrs %{
    balance: 2000,
    email: "some@updatedemail",
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    password: "someupdatedpassword",
    password_confirmation: "someupdatedpassword"
  }
  @invalid_attrs %{
    email: nil,
    first_name: nil,
    last_name: nil,
    password: nil,
    password_confirmation: nil,
    password_hash: nil
  }

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      result = json_response(conn, 200)["data"]

      assert id == Map.get(result, "id")
      assert "some first_name" == Map.get(result, "first_name")
      assert "some@email" == Map.get(result, "email")
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      result = json_response(conn, 200)["data"]
      assert id == Map.get(result, "id")
      assert "some updated first_name" == Map.get(result, "first_name")
      assert "some@updatedemail" == Map.get(result, "email")
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
