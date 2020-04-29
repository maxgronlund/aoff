defmodule AOFFWeb.Router do
  use AOFFWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AOFFWeb.Users.Auth
    plug AOFFWeb.System.Warning
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

  scope "/", AOFFWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/terms", TermsController, :index

    resources "/users", UserController, except: [:index] do
      resources "/order_items", Users.OrderItemController, only: [:create, :delete]
      resources "/orders", Users.OrderController
      resources "/membership", Users.MembershipController, only: [:new, :create]
    end

    resources "/reset_password", ResetPasswordController,
      only: [:new, :create, :edit, :update, :index]

    resources "/sessions", SessionController

    resources "/info", InfoController, only: [:index, :show] do
      resources "/about_aoff", Info.AboutController, only: [:show]
      # resources "/news", Info.NewsController, except: [:index, :show]
    end

    resources "/news", Info.NewsController, only: [:index, :show]
  end

  scope "/admin", as: :admin do
    pipe_through :browser
    get "/", AOFFWeb.Admin.AdminController, :index
    resources "/users", AOFFWeb.Admin.UserController
  end

  scope "/committee", as: :committee do
    pipe_through :browser

    resources "/", AOFFWeb.Committees.CommitteeController do
      resources "/members", AOFFWeb.Committees.MemberController, except: [:index, :show]
      resources "/meetings", AOFFWeb.Committees.MeetingController, only: [:show]
    end
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

  scope "/volunteer", as: :volunteer do
    pipe_through :browser
    get "/", AOFFWeb.Volunteer.VolunteerController, :index
    resources "/dates", AOFFWeb.Volunteer.DateController, except: [:show]
    resources "/users", AOFFWeb.Volunteer.UserController
    resources "/messages", AOFFWeb.Volunteer.MessageController, except: [:new, :create]

    resources "/memberships", AOFFWeb.Volunteer.MembershipController,
      only: [:index, :edit, :update]

    resources "/blogs", AOFFWeb.Volunteer.BlogController do
      resources "/posts", AOFFWeb.Volunteer.BlogPostController
    end

    resources "/committees", AOFFWeb.Volunteer.CommitteeController do
      resources "/members", AOFFWeb.Volunteer.MemberController, except: [:index, :show]
      resources "/meetings", AOFFWeb.Volunteer.MeetingController
    end
  end

  scope "/shop_assistant", as: :shop_assistant do
    pipe_through :browser
    resources "/dates", AOFFWeb.ShopAssistant.DateController, only: [:show]
    resources "/pick_ups", AOFFWeb.ShopAssistant.PickUpController, only: [:show]
    get "/", AOFFWeb.ShopAssistant.ShopAssistantController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", AOFFWeb do
  #   pipe_through :api
  # end
end
