defmodule AOFFWeb.Volunteer.VolunteerController do
  use AOFFWeb, :controller

  alias AOFFWeb.Users.Auth
  alias AOFF.System
  plug Auth
  plug :authenticate when action in [:index]

  def index(conn, _params) do
    {:ok, volunteer} =
      System.find_or_create_message(
        "/volunteer - volunteer",
        "Volunteer landing page",
        Gettext.get_locale()
      )

    {:ok, users} =
      System.find_or_create_message(
        "/volunteer - user",
        "Volunteer Users",
        Gettext.get_locale()
      )

    {:ok, opening_dates} =
      System.find_or_create_message(
        "/volunteer - dates",
        "Volunteer Opening dates",
        Gettext.get_locale()
      )

    {:ok, messages} =
      System.find_or_create_message(
        "/volunteer - messages",
        "Volunteer Messages",
        Gettext.get_locale()
      )

    {:ok, categories} =
      System.find_or_create_message(
        "/volunteer - categories",
        "Volunteer Categories",
        Gettext.get_locale()
      )

    {:ok, membership} =
      System.find_or_create_message(
        "/volunteer - memberships",
        "Memberships",
        Gettext.get_locale()
      )

    {:ok, committees} =
      System.find_or_create_message(
        "/volunteer - committees",
        "Committees",
        Gettext.get_locale()
      )

    {:ok, products} =
      System.find_or_create_message(
        "/volunteer - products",
        "Products",
        Gettext.get_locale()
      )


    render(
      conn,
      "index.html",
      volunteer: volunteer,
      users: users,
      messages: messages,
      opening_dates: opening_dates,
      categories: categories,
      membership: membership,
      committees: committees,
      products: products
    )
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.volunteer do
      assign(conn, :page, :volunteer)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
