defmodule ExpenseJarWeb.Router do
  use ExpenseJarWeb, :router

  alias ExpenseJarWeb.Plugs

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ExpenseJarWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Plugs.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :require_authenticated_user do
    plug Plugs.RequireLogin
  end

  scope "/auth", ExpenseJarWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  scope "/", ExpenseJarWeb do
    pipe_through :browser

    get "/", PageController, :index
    live "/live", PageLive, :index
  end

  scope "/", ExpenseJarWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

    live "/lists", ListLive.Index, :index
    live "/lists/new", ListLive.Index, :new
    live "/lists/:id/edit", ListLive.Index, :edit

    live "/lists/:id", ListLive.Show, :show
    live "/lists/:id/show/edit", ListLive.Show, :edit

    live "/subscriptions", SubscriptionLive.Index, :index
    live "/subscriptions/new", SubscriptionLive.Index, :new
    live "/subscriptions/:id/edit", SubscriptionLive.Index, :edit

    live "/subscriptions/:id", SubscriptionLive.Show, :show
    live "/subscriptions/:id/show/edit", SubscriptionLive.Show, :edit
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
