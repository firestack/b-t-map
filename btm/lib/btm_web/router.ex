defmodule BtmWeb.Router do
  use BtmWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BtmWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BtmWeb do
    pipe_through [:api]
    get "/geojson/stops", PageController, :stops_geojson
  end

  scope "/", BtmWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", BtmWeb do
  #   pipe_through :api
  # end
end
