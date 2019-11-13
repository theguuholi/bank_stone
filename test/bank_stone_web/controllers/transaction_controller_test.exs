defmodule BankStoneWeb.TransactionControllerTest do
  use BankStoneWeb.ConnCase

  alias BankStone.Accounts
  alias BankStone.Transactions
  import BankStoneWeb.Auth.Guardian

  @create_attrs %{
    email: "some@email",
    first_name: "some first_name",
    last_name: "some last_name",
    password: "somepassword",
    password_confirmation: "somepassword"
  }

  def transactions_fixture do
    [
      %{
        value: "100",
        account_from: "123123",
        type: "transfer",
        account_to: "112112",
        date: ~D[2019-11-08]
      },
      %{
        value: "100",
        account_from: "123123",
        type: "withdraw",
        account_to: "112112",
        date: ~D[2019-11-08]
      },
      %{
        value: "100",
        account_from: "123123",
        type: "transfer",
        account_to: "112112",
        date: ~D[2019-11-07]
      },
      %{
        value: "100",
        account_from: "123123",
        type: "transfer",
        account_to: "112112",
        date: ~D[2019-11-17]
      },
      %{
        value: "100",
        account_from: "123123",
        type: "transfer",
        account_to: "112112",
        date: ~D[2019-10-07]
      },
      %{
        value: "100",
        account_from: "123123",
        type: "transfer",
        account_to: "112112",
        date: ~D[2018-10-07]
      }
    ]
    |> Enum.map(fn transaction -> Transactions.insert_transaction(transaction) end)
  end

  def fixture(:user) do
    transactions_fixture()
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "Transactions" do
    test "should list all transactions", %{conn: conn} do
      logged_user = fixture(:user)
      {:ok, token, _} = encode_and_sign(logged_user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = get(conn, Routes.transaction_path(conn, :all))
      result = json_response(conn, 200)["data"]

      total = Map.get(result, "total")
      total_transactions = Map.get(result, "transactions") |> Enum.count()

      assert 600.0 == total
      assert 6 == total_transactions
    end

    test "should list transactions by year", %{conn: conn} do
      logged_user = fixture(:user)
      {:ok, token, _} = encode_and_sign(logged_user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = get(conn, Routes.transaction_path(conn, :year, "2019"))
      result = json_response(conn, 200)["data"]

      total = Map.get(result, "total")
      total_transactions = Map.get(result, "transactions") |> Enum.count()

      assert 500.0 == total
      assert 5 == total_transactions
    end

    test "should list transactions by month", %{conn: conn} do
      logged_user = fixture(:user)
      {:ok, token, _} = encode_and_sign(logged_user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = get(conn, Routes.transaction_path(conn, :month, "2019", "10"))
      result = json_response(conn, 200)["data"]

      total = Map.get(result, "total")
      total_transactions = Map.get(result, "transactions") |> Enum.count()

      assert 100.0 == total
      assert 1 == total_transactions
    end

    test "should list transactions by day", %{conn: conn} do
      logged_user = fixture(:user)
      {:ok, token, _} = encode_and_sign(logged_user, %{}, token_type: :access)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = get(conn, Routes.transaction_path(conn, :day, "2019-11-08"))
      result = json_response(conn, 200)["data"]

      total = Map.get(result, "total")
      total_transactions = Map.get(result, "transactions") |> Enum.count()

      assert 200.0 == total
      assert 2 == total_transactions
    end
  end
end
