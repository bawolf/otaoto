defmodule Once.Router do
  use Once.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/api", Once do
    pipe_through :api

    post "/create", SecretAPIController, :create
    get "/show/:slug/:key", SecretAPIController, :show
  end

  scope "/", Once do
    pipe_through :browser # Use the default browser stack

    get "/", SecretController, :new
    post "/create", SecretController, :create
    get "/show/:slug/:key", SecretController, :show
    get "/gate/:slug/:key", SecretController, :gate
    get "/gone", SecretController, :gone
  end
end
