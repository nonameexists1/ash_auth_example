defmodule AshAuthExampleWeb.Router do
  use AshAuthExampleWeb, :router

  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AshAuthExampleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Triplex.SubdomainPlug,
      endpoint: AshAuthExampleWeb.Endpoint,
      tenant_handler: &AshAuthExampleWeb.TenantHelper.transform_tenant/1

    plug Triplex.EnsurePlug
    plug :put_tenant_to_session
    plug :put_tenant_to_ash
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
  end

  scope "/", AshAuthExampleWeb do
    pipe_through :browser

    ash_authentication_live_session :authenticated_routes do
      # in each liveview, add one of the following at the top of the module:
      #
      # If an authenticated user must be present:
      # on_mount {AshAuthExampleWeb.LiveUserAuth, :live_user_required}
      #
      # If an authenticated user *may* be present:
      # on_mount {AshAuthExampleWeb.LiveUserAuth, :live_user_optional}
      #
      # If an authenticated user must *not* be present:
      # on_mount {AshAuthExampleWeb.LiveUserAuth, :live_no_user}
    end
  end

  scope "/", AshAuthExampleWeb do
    pipe_through :browser

    get "/", PageController, :home
    auth_routes AuthController, AshAuthExample.Accounts.User, path: "/auth"
    sign_out_route AuthController

    # Remove these if you'd like to use your own authentication views
    sign_in_route register_path: "/register",
                  reset_path: "/reset",
                  auth_routes_prefix: "/auth",
                  on_mount: [{AshAuthExampleWeb.LiveUserAuth, :live_no_user}],
                  overrides: [
                    AshAuthExampleWeb.AuthOverrides,
                    AshAuthentication.Phoenix.Overrides.Default
                  ]

    # Remove this if you do not want to use the reset password feature
    reset_route auth_routes_prefix: "/auth",
                overrides: [
                  AshAuthExampleWeb.AuthOverrides,
                  AshAuthentication.Phoenix.Overrides.Default
                ]
  end

  # Other scopes may use custom stacks.
  # scope "/api", AshAuthExampleWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ash_auth_example, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AshAuthExampleWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  def put_tenant_to_session(conn, _opts) do
    conn
    |> Plug.Conn.put_session(:current_tenant, conn.assigns.current_tenant)
  end

  def put_tenant_to_ash(conn, _opts) do
    conn
    |> Ash.PlugHelpers.set_tenant(conn.assigns.current_tenant)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> send_resp(401, "")
      |> halt()
    end
  end
end
