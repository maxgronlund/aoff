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



    render(
      conn,
      "index.html",
      volunteer: volunteer,
    )

    # render(
    #   conn,
    #   "index.html",
    #   host_message: host_message,
    #   purchaser_message: purchaser_message,
    #   volunteer: volunteer,
    #   users: users,
    #   messages: messages,
    #   opening_dates: opening_dates,
    #   categories: categories,
    #   news: news,
    #   membership: membership,
    #   committees: committees,
    #   products: products,
    #   orders_message: orders_message
    # )
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.volunteer do
      conn
      |> assign(:selected_menu_item, :volunteer)
      |> assign(:title, gettext("Volunteer"))
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
