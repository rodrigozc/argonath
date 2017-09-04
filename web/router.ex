defmodule Argonath.Router do
  use Argonath.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug Argonath.IdentifyAPI, repo: Argonath.Repo
    plug Argonath.Plugins.XMLSecurity
  end

  scope "/argonath/ui", Argonath do
    pipe_through :browser
    get "/", PageController, :index
    resources "/apis", APIController
  end

  scope "/", Argonath do
    pipe_through :api
    match :*, "/*path", ProxyController, :execute
  end

end
