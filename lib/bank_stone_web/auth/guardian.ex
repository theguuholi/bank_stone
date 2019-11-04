defmodule BankStoneWeb.Auth.Guardian do
  @moduledoc """
      Guardian Implements to define jwt token
  """
  use Guardian, otp_app: :bank_stone
  alias BankStone.Accounts

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Accounts.get_user!(id)
    {:ok, resource}
  end
end
