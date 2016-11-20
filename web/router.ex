defmodule Once.Router do
  use Once.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Once do
    pipe_through :browser # Use the default browser stack

    get "/", SecretController, :new
    get "/confirm", SecretController, :confirm
    resources "/", SecretController, only: [:new, :create, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Once do
  #   pipe_through :api
  # end
end
