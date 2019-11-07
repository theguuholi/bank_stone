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

  @create_user %{
    email: "some2@email",
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
      logged_user = fixture(:user)
      {:ok, token, _} = encode_and_sign(logged_user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = get(conn, Routes.user_path(conn, :show))
      result = json_response(conn, 200)["data"]
      assert "1000.00" == Map.get(result, "account") |> Map.get("balance")

      {:ok, user_account} = Accounts.create_user(@create_user)
      transfer_data = %{"to_account_id" => user_account.accounts.id, "value" => "100"}
      conn = put(conn, Routes.operation_path(conn, :transfer), transfer_data)
      result = json_response(conn, 200)["data"]

      expected = %{"message" => "Transfer to: #{user_account.accounts.id} Success"}
      assert result == expected

      conn = get(conn, Routes.user_path(conn, :show))
      result = json_response(conn, 200)["data"]
      assert "900.00" == Map.get(result, "account") |> Map.get("balance")
    end

    test "should transfer and return error because value account", %{conn: conn} do
      logged_user = fixture(:user)
      {:ok, token, _} = encode_and_sign(logged_user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = get(conn, Routes.user_path(conn, :show))
      result = json_response(conn, 200)["data"]
      assert "1000.00" == Map.get(result, "account") |> Map.get("balance")

      {:ok, user_account} = Accounts.create_user(@create_user)
      transfer_data = %{"to_account_id" => user_account.accounts.id, "value" => "10000"}
      conn = put(conn, Routes.operation_path(conn, :transfer), transfer_data)
      result = json_response(conn, 404)

      expected = %{"error" => "You can`t have negative balance"}
      assert result == expected

      conn = get(conn, Routes.user_path(conn, :show))
      result = json_response(conn, 200)["data"]
      assert "1000.00" == Map.get(result, "account") |> Map.get("balance")
    end

    test "should withdraw a value", %{conn: conn} do
      logged_user = fixture(:user)
      {:ok, token, _} = encode_and_sign(logged_user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = get(conn, Routes.user_path(conn, :show))
      result = json_response(conn, 200)["data"]
      assert "1000.00" == Map.get(result, "account") |> Map.get("balance")

      transfer_data = %{"value" => "100"}
      conn = put(conn, Routes.operation_path(conn, :withdraw), transfer_data)

      conn = get(conn, Routes.user_path(conn, :show))
      result = json_response(conn, 200)["data"]
      assert "900.00" == Map.get(result, "account") |> Map.get("balance")
    end

    test "should withdraw a negative value", %{conn: conn} do
      logged_user = fixture(:user)
      {:ok, token, _} = encode_and_sign(logged_user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = get(conn, Routes.user_path(conn, :show))
      result = json_response(conn, 200)["data"]
      assert "1000.00" == Map.get(result, "account") |> Map.get("balance")

      transfer_data = %{"value" => "1001"}
      conn = put(conn, Routes.operation_path(conn, :withdraw), transfer_data)
      result = json_response(conn, 404)

      expected = %{"error" => "You can`t have negative balance"}
      assert result == expected

      conn = get(conn, Routes.user_path(conn, :show))
      result = json_response(conn, 200)["data"]
      assert "1000.00" == Map.get(result, "account") |> Map.get("balance")
    end
  end
end
