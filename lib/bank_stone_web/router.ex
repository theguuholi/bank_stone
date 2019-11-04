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

    get "/users", UserController, :index
    get "/users", UserController, :show
    put "/users", UserController, :update
  end
end
