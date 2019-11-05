defmodule BankStoneWeb.Auth.Pipeline do
  @moduledoc """
      Restrict access resources
  """
  use Guardian.Plug.Pipeline,
    otp_app: :bank_stone,
    module: BankStoneWeb.Auth.Guardian,
    error_handler: BankStoneWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
