defmodule ExpenseJarWeb.Router do
  use ExpenseJarWeb, :router

  import ExpenseJarWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ExpenseJarWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", ExpenseJarWeb do
    pipe_through :browser

    get "/:provider", UserAuth, :request
    get "/:provider/callback", UserAuth, :callback
    post "/:provider/callback", UserAuth, :callback
    delete "/logout", UserAuth, :logout_user
  end

  scope "/", ExpenseJarWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/", PageController, :index
  end

  scope "/", ExpenseJarWeb do
    pipe_through [:browser, :require_authenticated_user]

    resources "/lists", ListController, except: [:show]
    live "/lists/:list_id", ListLive.Show, :show
    live "/lists/:list_id/subscriptions/new", ListLive.Show, :new
    live "/lists/:list_id/subscriptions/:subscription_id/edit", ListLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExpenseJarWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ExpenseJarWeb.Telemetry
    end
  end
end
