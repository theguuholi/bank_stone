defmodule BankStone.AuthTest do
  use BankStone.DataCase

  alias BankStone.Accounts

  describe "users" do
    alias BankStone.Accounts.User

    @valid_attrs %{
      email: "teste@teste.com",
      first_name: "Teste",
      last_name: "Oliveira",
      password: "teste@1234",
      password_confirmation: "teste@1234",
      role: "user"
    }

    test "create_user/1 and verifyPassword" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)

      assert {:ok, %User{} = user} ==
               Comeonin.Argon2.check_pass(user, "teste@1234", hash_key: :password_hash)

      assert user.first_name == "Teste"
    end

    test "authenticate_user/2 and verifyPassword" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)

      {:ok, user_authenticated} = Accounts.authenticate(user.email, "teste@1234")
      assert user.email == user_authenticated.email
    end

    test "authenticate_user/2 and invalid password" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)

      assert {:error, :unauthorized} = Accounts.authenticate(user.email, "test1234")
    end

    test "authenticate_user/2 user does not exist" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)

      assert {:error, :not_found} = Accounts.authenticate("tesdf", "teste@1234")
    end
  end
end
