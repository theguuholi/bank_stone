defmodule BankStone.Email.Email do
  @moduledoc """
    Module responsible to filter transactions
  """
  import Bamboo.Email

  def withdraw_email(account, value) do
    new_email(
      to: account.user.email,
      from: "g.92oliveira@gmail.com",
      subject: "STONE - You Performed a withdraw ",
      html_body:
        "<strong>#{account.user.first_name}</strong><p>Withdraw Amount: #{value}</p><p>New Balance: #{
          account.balance
        }</p>",
      text_body: "Thanks for joining!"
    )
  end
end
