defmodule BankStoneWeb.UserControllerTest do
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
      user = fixture(:user)
      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = get(conn, Routes.user_path(conn, :index))
      assert Enum.count(json_response(conn, 200)["data"]) == 1
    end
  end

  describe "manipulate user" do
    test "renders user when data is valid", %{conn: conn} do
      user = %{
        email: "some2@email",
        first_name: "some first_name",
        last_name: "some last_name",
        password: "somepassword",
        password_confirmation: "somepassword"
      }

      conn = post(conn, Routes.user_path(conn, :create), user: user)
      result = json_response(conn, 201)

      assert "some first_name" == Map.get(result, "first_name")
      assert "some2@email" == Map.get(result, "email")
    end

    test "renders user when data is notfound", %{conn: conn} do
      user = %{
        email: "some2@email",
        first_name: "some first_name",
        last_name: "some last_name",
        passwor: "somepassword",
        password_confirmation: "somepassword",
        abc: "somepassword"
      }

      conn = post(conn, Routes.user_path(conn, :create), user: user)
      result = json_response(conn, 201)

      assert "some first_name" == Map.get(result, "first_name")
      assert "some2@email" == Map.get(result, "email")
    end

    test "authenticate success", %{conn: conn} do
      user = fixture(:user)

      conn = post(conn, Routes.user_path(conn, :signin), email: user.email, password: "somepassword")
      result = json_response(conn, 201)

      assert "some first_name" == Map.get(result, "first_name")
    end

    test "authenticate invalid email", %{conn: conn} do
      fixture(:user)
      
      conn = post(conn, Routes.user_path(conn, :signin), email: "dsf", password: "somepasword")
      result = json_response(conn, 401)

      assert "Unauthorized" == Map.get(result, "errors") |> Map.get("detail")
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = fixture(:user)
      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "show authenticated user", %{conn: conn} do
      user = fixture(:user)
      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = get(conn, Routes.user_path(conn, :show))
      result = json_response(conn, 200)["data"] |> List.first()
      assert "some@email" == Map.get(result, "email")    
    end

    test "try to show an user without authentication", %{conn: conn} do
      fixture(:user)

      conn = get(conn, Routes.user_path(conn, :show))
      result = json_response(conn, 401)
      assert "unauthenticated" == Map.get(result, "error")    
    end
  end


  describe "update user" do
    test "renders user when data is valid", %{conn: conn} do
      user = fixture(:user)
      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = put(conn, Routes.user_path(conn, :update), user: @update_attrs)
      id = Guardian.Plug.current_resource(conn).id

      conn = get(conn, Routes.user_path(conn, :show))

      result = json_response(conn, 200)["data"] |> List.first()
      assert id == Map.get(result, "id")
      assert "some updated first_name" == Map.get(result, "first_name")
      assert "some@updatedemail" == Map.get(result, "email")
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = fixture(:user)
      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = put(conn, Routes.user_path(conn, :update), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
