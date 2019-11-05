defmodule BankStone.AccountsTest do
  use BankStone.DataCase

  alias BankStone.Accounts

  describe "users" do
    alias BankStone.Accounts.User

    @valid_attrs %{
      email: "some@email",
      first_name: "some first_name",
      last_name: "some last_name",
      password: "somepassword",
      password_confirmation: "somepassword"
    }
    @invalid_email %{
      email: "someemail",
      first_name: "some first_name",
      last_name: "some last_name",
      password: "somepassword",
      password_confirmation: "somepassword"
    }
    @update_attrs %{
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
      password_confirmation: nil
    }

    @passowrd_not_match %{
      email: "teste@teste.com",
      first_name: "Teste",
      last_name: "Oliveira",
      password: "1234567",
      password_confirmation: "12345"
    }

    @without_attrs %{
      email: "teste@teste.com",
      first_name: "Teste",
      password: "teste@1234",
      password_confirmation: "teste@1234",
      role: "user"
    }

    @password_short %{
      email: "teste@teste.com",
      first_name: "Teste",
      last_name: "Oliveira",
      password: "123",
      password_confirmation: "123",
      role: "user"
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
      assert Accounts.get_user(user.id).first_name == user.first_name
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some@email"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
    end

    test "create_user/1 with password does not match" do
      {:error, user} = Accounts.create_user(@passowrd_not_match)
      assert "Password does not match" in errors_on(user).password_confirmation
    end

    test "create_user/1 with short password" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@password_short)
    end

    test "create_user/1 with invalid email" do
      {:error, user} = Accounts.create_user(@invalid_email)
      assert "Invalid email format!" in errors_on(user).email
    end

    test "create_user/1 without attibuts" do
      assert {:error, changeset} = Accounts.create_user(@without_attrs)
      assert "can't be blank" in errors_on(changeset).last_name
      assert %{last_name: ["can't be blank"]} = errors_on(changeset)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some@updatedemail"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.role == "user"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user.first_name == Accounts.get_user(user.id).first_name
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
