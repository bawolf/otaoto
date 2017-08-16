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

  scope "/api", Once, as: :api do
    pipe_through :api

    post "/create", API.SecretController, :create
    get "/show/:slug/:key", API.SecretController, :show
  end

  scope "/", Once do
    pipe_through :browser

    get "/", HTML.SecretController, :new
    post "/create", HTML.SecretController, :create
    get "/show/:slug/:key", HTML.SecretController, :show
    get "/gate/:slug/:key", HTML.SecretController, :gate
    get "/gone", HTML.SecretController, :gone
  end
end
