defmodule KiraWeb.Router do
  use KiraWeb, :router

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

  scope "/", KiraWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", KiraWeb do
    pipe_through :api

    resources "/webhook/issues", Webhooks.IssueController, only: [:create]
  end
end
