defmodule AOFFWeb.Router do
  use AOFFWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AOFFWeb.Users.Auth
    plug AOFFWeb.Users.OrderItemsInBasketCount
    plug AOFFWeb.System.Warning
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
      resources "/orders", Users.OrderController, except: [:delete]
      resources "/membership", Users.MembershipController
    end

    resources "/reset_password", ResetPasswordController, only: [:new, :create, :edit, :update, :index]

    resources "/sessions", SessionController

    resources "/info", InfoController, only: [:index, :show] do
      resources "/about_aoff", Info.AboutController, only: [:show]
      resources "/news", Info.NewsController, except: [:index, :show]
    end
    resources "/news", Info.NewsController, only: [:index, :show]



  end

  scope "/shop", as: :shop do
    pipe_through :browser
    get "/", AOFFWeb.Shop.ShopController, :index
    resources "/dates", AOFFWeb.Shop.DateController, only: [:show]
    resources "/checkout/", AOFFWeb.Shop.CheckoutController, only: [:show, :update]
  end

  scope "/admin", as: :admin do
    pipe_through :browser
    get "/", AOFFWeb.Admin.AdminController, :index
    resources "/users", AOFFWeb.Admin.UserController
  end

  scope "/volunteer", as: :volunteer do
    pipe_through :browser
    get "/", AOFFWeb.Volunteer.VolunteerController, :index
    resources "/dates", AOFFWeb.Volunteer.DateController
    resources "/users", AOFFWeb.Volunteer.UserController
    resources "/messages", AOFFWeb.Volunteer.MessageController, except: [:new, :create]

    resources "/blogs", AOFFWeb.Volunteer.BlogController do
      resources "/posts", AOFFWeb.Volunteer.BlogPostController
    end
  end

  scope "/purchaser", as: :purchaser do
    pipe_through :browser
    get "/", AOFFWeb.Purchaser.PurchaserController, :index


    resources "/dates", AOFFWeb.Purchaser.DateController, only: [:index, :show]
    resources "/products", AOFFWeb.Purchaser.ProductController
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
