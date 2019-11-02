defmodule BankStone.AccountsTest do
  use BankStone.DataCase

  alias BankStone.Accounts

  describe "users" do
    alias BankStone.Accounts.User

    @valid_attrs %{
      balance: 1000,
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
      balance: nil,
      email: nil,
      first_name: nil,
      last_name: nil,
      password: nil,
      password_confirmation: nil
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user_fixture()
      assert Enum.count(Accounts.list_users()) == 1
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id).first_name == user.first_name
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.balance == Decimal.new("1000")
      assert user.email == "some@email"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.balance == Decimal.new("2000")
      assert user.email == "some@updatedemail"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.role == "user"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user.first_name == Accounts.get_user!(user.id).first_name
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
