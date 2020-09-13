defmodule AOFFWeb.Router do
  use AOFFWeb, :router
  use Airbrakex.Plug
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AOFFWeb.System.Title
    plug AOFFWeb.Users.Auth
    plug AOFFWeb.System.Warning
    plug AOFFWeb.System.SetLocale
    plug :put_user_token
  end

  defp put_user_token(conn, _) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # if Mix.env == :dev do
  #   forward "/sent_emails", Bamboo.EmailPreviewPlug
  # end

  pipeline :admins_only do
    plug BasicAuth, use_config: {:aoff_web, :basic_auth}
  end

  scope "/", AOFFWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/terms", TermsController, :index
    get "/payment_terms", PaymentTermsController, :show
    get "/unsubscribe_to_news/:id", Users.UnsubscribeToNewsController, :show
    resources "/calendar", Content.CalendarController, only: [:index, :show]

    resources "/users", UserController, except: [:index] do
      resources "/order_items", Users.OrderItemController, only: [:create, :delete]
      resources "/orders", Users.OrderController, only: [:show, :delete]
      resources "/invoices", Users.InvoiceController, only: [:index, :show]
      resources "/membership", Users.MembershipController, only: [:new, :create]
      resources "/welcome", Users.WelcomeController, only: [:index]
      resources "/confirm_email", Users.ConfirmEmailController, only: [:index]
    end

    resources "/resend_confirm_email", ResendConfirmEmailController, only: [:new, :create, :index]

    resources "/confirm_email", Users.ConfirmEmailController, only: [:show]

    resources "/reset_password", ResetPasswordController,
      only: [:new, :create, :edit, :update, :index]

    resources "/sessions", SessionController

    resources "/about", Content.AboutController, only: [:index, :show] do
      resources "/page", Content.PageController, only: [:show]
    end
  end

  scope "/admin", as: :admin do
    pipe_through [:browser, :admins_only]
    get "/", AOFFWeb.Admin.AdminController, :index
    resources "/users", AOFFWeb.Admin.UserController
    live_dashboard "/dashboard", metrics: AOFF.Web.Telemetry
    resources "/associations", AOFFWeb.Admin.AssociationController
  end

  scope "/committee", as: :committee do
    pipe_through :browser

    resources "/", AOFFWeb.Committees.CommitteeController do
      resources "/meetings", AOFFWeb.Committees.MeetingController, only: [:show]
    end
  end

  scope "/events", as: :events do
    resources "/participant", AOFFWeb.Events.ParticipantController, only: [:create, :delete]
  end

  scope "/purchaser", as: :purchaser do
    pipe_through :browser
    get "/", AOFFWeb.Purchaser.PurchaserController, :index

    resources "/dates", AOFFWeb.Purchaser.DateController, only: [:index, :show] do
      resources "/products_notes", AOFFWeb.Purchaser.ProductNoteController
    end

    resources "/products", AOFFWeb.Purchaser.ProductController
  end

  scope "/shop", as: :shop do
    pipe_through :browser
    get "/", AOFFWeb.Shop.ShopController, :index
    resources "/dates", AOFFWeb.Shop.DateController, only: [:show]
    resources "/checkout/:id", AOFFWeb.Shop.CheckoutController, only: [:edit, :update]

    get "/payment_accepted/:id", AOFFWeb.Shop.PaymentAcceptedController, :index
    get "/payment_declined/:id", AOFFWeb.Shop.PaymentDeclinedController, :index
    get "/payment_callback/:id", AOFFWeb.Shop.PaymentCallbackController, :index
  end

  scope "/shop_assistant", as: :shop_assistant do
    pipe_through :browser

    resources "/dates", AOFFWeb.ShopAssistant.DateController,
      only: [:show, :index, :edit, :update]

    resources "/pick_ups", AOFFWeb.ShopAssistant.PickUpController, only: [:show]
    resources "/order_list", AOFFWeb.ShopAssistant.OrderListController, only: [:show]
    get "/", AOFFWeb.ShopAssistant.ShopAssistantController, :index

    resources "/users", AOFFWeb.ShopAssistant.UserController, only: [:index] do
      resources "/orders", AOFFWeb.ShopAssistant.OrderController, only: [:new, :update, :delete]
    end

    resources "/orders", AOFFWeb.ShopAssistant.OrderController, only: [] do
      resources "/order_items", AOFFWeb.ShopAssistant.OrderItemController,
        only: [:create, :delete]
    end
  end

  scope "/system", as: :system do
    pipe_through :browser
    resources "/sms_messages", AOFFWeb.System.SMSMessageController
  end

  scope "/volunteer", as: :volunteer do
    pipe_through :browser
    get "/", AOFFWeb.Volunteer.VolunteerController, :index
    resources "/dates", AOFFWeb.Volunteer.DateController, except: [:show]
    resources "/users", AOFFWeb.Volunteer.UserController
    resources "/newsletters", AOFFWeb.Volunteer.NewsletterController

    put "/send_newsletter/:id", AOFFWeb.Volunteer.SendNewsletterController, :update

    resources "/users_csv", AOFFWeb.Volunteer.UsersCSVController, only: [:index]
    resources "/messages", AOFFWeb.Volunteer.MessageController, except: [:new, :create]

    resources "/memberships", AOFFWeb.Volunteer.MembershipController,
      only: [:index, :edit, :update]

    resources "/calendar", AOFFWeb.Volunteer.CalendarController

    resources "/orders", AOFFWeb.Volunteer.OrderController,
      only: [:index, :show, :delete, :edit, :update] do
      resources "/order_items", AOFFWeb.Volunteer.OrderItemController, only: [:create, :delete]
    end

    resources "/categories", AOFFWeb.Volunteer.CategoryController do
      resources "/pages", AOFFWeb.Volunteer.PageController
    end

    resources "/committees", AOFFWeb.Volunteer.CommitteeController do
      resources "/members", AOFFWeb.Volunteer.MemberController, except: [:index, :show]
      resources "/meetings", AOFFWeb.Volunteer.MeetingController, except: [:index, :show]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", AOFFWeb do
  #   pipe_through :api
  # end
end
