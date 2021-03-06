defmodule InstagramWeb.Router do
  use InstagramWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug InstagramWeb.Guardian.Pipeline
  end

  pipeline :ensure_not_auth do
    plug Guardian.Plug.EnsureNotAuthenticated
  end

  pipeline :ensuer_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end


  pipeline :api do
    plug :accepts, ["json"]
  end

  # Only authenticated
  scope "/", InstagramWeb do
    pipe_through [:browser, :ensuer_auth]

    resources "/posts", PostController, except: [:show]
    get "/logout", SessionController, :destroy
  end
  # Only unauthenticated
  scope "/", InstagramWeb do
    pipe_through [:browser, :ensure_not_auth]

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
    get "/login", SessionController, :new
    post "/login", SessionController, :create
  end

  scope "/", InstagramWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/posts", PostController, only: [:show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", InstagramWeb do
  #   pipe_through :api
  # end
end
