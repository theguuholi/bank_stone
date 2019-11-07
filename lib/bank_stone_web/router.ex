defmodule BankStoneWeb.Router do
  use BankStoneWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug BankStoneWeb.Auth.Pipeline
  end

  scope "/api/auth", BankStoneWeb do
    pipe_through :api
    post "/signup", UserController, :create
    post "/signin", UserController, :signin
  end

  scope "/api", BankStoneWeb do
    pipe_through [:api, :auth]

    put "/operations/transfer", OperationController, :transfer
    put "/operations/withdraw", OperationController, :withdraw

    get "/transactions/all", TransactionController, :all
    get "/transactions/year/:year", TransactionController, :year
    get "/transactions/year/:year/month/:month", TransactionController, :month
    get "/transactions/year/:year/month/:month/day/:day", TransactionController, :day

    get "/users", UserController, :index
    get "/user", UserController, :show
    put "/users", UserController, :update
  end
end
