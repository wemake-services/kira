defmodule KiraWeb.Router do
  use KiraWeb, :router

  @csp "default-src 'self'; script-src 'self'; style-src 'self';"

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers, %{"content-security-policy" => @csp}
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

    resources "/webhook/gitlab", Webhooks.GitlabController, only: [:create]
  end

  scope "/auth", KiraWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
