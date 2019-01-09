defmodule HostListrWeb.Router do
  use HostListrWeb, :router

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

  scope "/", HostListrWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/subscribed_lists", SubscribedListController, only: [:index, :new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", HostListrWeb do
  #   pipe_through :api
  # end
end
