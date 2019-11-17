defmodule BankStone.Email.EmailTest do
  use ExUnit.Case
  use Bamboo.Test
  alias BankStone.Email, as: EmailServer

  test "withdraw_email " do
    account = %{
      user: %{email: "joelma@gmail.com", first_name: "Joelma"},
      balance: Decimal.new("100000")
    }

    email = BankStone.Email.Email.withdraw_email(account, 100)
    assert email.to == "joelma@gmail.com"
    assert email.from == "g.92oliveira@gmail.com"

    assert email.html_body =~
             "<strong>Joelma</strong><p>Withdraw Amount: 100</p><p>New Balance: 100000</p>"

    assert email.text_body =~ "Thanks for joining!"
  end

  test "the user gets a withdraw email " do
    account = %{
      user: %{email: "joelma@gmail.com", first_name: "Joelma"},
      balance: Decimal.new("100000")
    }

    expected_email =
      EmailServer.Email.withdraw_email(account, 100)
      |> EmailServer.Mailer.deliver_now()

    assert_delivered_email(expected_email)
  end
end
