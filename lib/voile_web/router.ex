defmodule VoileWeb.Router do
  use VoileWeb, :router

  import VoileWeb.UserAuth
  # import VoileWeb.UserAuthGoogle

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VoileWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug VoileWeb.Plugs.GetCurrentPath
    plug VoileWeb.Utils.SideBarMenuMaster
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VoileWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/about", PageController, :about
  end

  # Other scopes may use custom stacks.
  # scope "/api", VoileWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:voile, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: VoileWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", VoileWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{VoileWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/register", UserRegistrationLive, :new
      live "/login", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", VoileWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [
        {VoileWeb.UserAuth, :ensure_authenticated},
        {VoileWeb.Utils.SaveRequestUri, :save_request_uri},
        {VoileWeb.Utils.SideBarMenuMaster, :master_menu}
      ] do
      scope "/manage" do
        live "/", DashboardLive, :index

        scope "/catalog" do
          live "/", Dashboard.Catalog.Index, :index

          scope "/collections" do
            live "/", Dashboard.Catalog.CollectionLive.Index, :index
            live "/new", Dashboard.Catalog.CollectionLive.Index, :new
            live "/:id/edit", Dashboard.Catalog.CollectionLive.Index, :edit

            live "/:id", Dashboard.Catalog.CollectionLive.Show, :show
            live "/:id/show/edit", Dashboard.Catalog.CollectionLive.Show, :edit
          end

          scope "/items" do
            live "/", Dashboard.Catalog.ItemLive.Index, :index
            live "/new", Dashboard.Catalog.ItemLive.Index, :new
            live "/:id/edit", Dashboard.Catalog.ItemLive.Index, :edit

            live "/:id", Dashboard.Catalog.ItemLive.Show, :show
            live "/:id/show/edit", Dashboard.Catalog.ItemLive.Show, :edit
          end
        end

        scope "/circulation" do
          live "/", Dashboard.Circulation.Index, :index
        end

        scope "/master" do
          live "/", Dashboard.Master.MasterLive

          scope "/creators" do
            live "/", Dashboard.Master.CreatorLive.Index, :index
            live "/new", Dashboard.Master.CreatorLive.Index, :new
            live "/:id/edit", Dashboard.Master.CreatorLive.Index, :edit

            live "/:id", Dashboard.Master.CreatorLive.Show, :show
            live "/:id/show/edit", Dashboard.Master.CreatorLive.Show, :edit
          end
        end

        scope "/metaresource" do
          live "/", Dashboard.Metaresource.MetaresourceLive
          resources "/metadata_vocabularies", VocabularyController
          resources "/metadata_properties", PropertyController
          resources "/resource_class", ResourceClassController

          scope "/resource_template" do
            live "/new", Dashboard.MetaResource.ResourceTemplateLive.New, :new
            live "/:id/edit", Dashboard.MetaResource.ResourceTemplateLive.Edit, :edit
            resources "/", ResourceTemplateController, except: [:new, :edit]
          end

          resources "/resource_templ_property", ResourceTemplatePropertyController
        end

        scope "/settings" do
          live "/", Dashboard.Settings.SettingLive, :index
          live "/user_profile", UserSettingsLive, :edit
          live "/confirm_email/:token", UserSettingsLive, :confirm_email
        end
      end
    end
  end

  scope "/", VoileWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{VoileWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  scope "/auth/google", VoileWeb do
    pipe_through [:browser]
    get "/", GoogleAuthController, :request
    get "/callback", GoogleAuthController, :callback
  end
end
