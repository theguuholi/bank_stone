defmodule BankStoneWeb.Router do
  use BankStoneWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankStoneWeb do
    pipe_through :api
  end
end
