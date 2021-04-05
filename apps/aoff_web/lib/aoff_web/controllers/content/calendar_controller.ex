defmodule AOFFWeb.Content.CalendarController do
  use AOFFWeb, :controller

  alias AOFF.Content
  alias AOFF.System
  alias AOFF.Events
  alias AOFF.Events.Participant

  def index(conn, _params) do
    prefix = conn.assigns.prefix
    {:ok, calendar} = Content.find_or_create_category(prefix, "Calendar")

    {:ok, message} =
      System.find_or_create_message(
        prefix,
        "Calendar",
        "Calendar",
        Gettext.get_locale()
      )

    conn
    |> assign(:selected_menu_item, :calendar)
    |> render("index.html", calendar: calendar, message: message)
  end

  def show(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix

    case Content.get_page!(prefix, "Calendar", id) do
      nil ->
        conn
        |> put_flash(:info, gettext("Language updated"))
        |> redirect(to: Routes.about_path(conn, :index))

      page ->
        participants = Events.list_participants(prefix, :all, page.id)
        participant = participant(prefix, conn, page)

        changeset =
          case conn.assigns.current_user do
            %AOFF.Users.User{} = _user ->
              Events.change_participant(%Participant{})

            _ ->
              nil
          end

        conn
        |> assign(:selected_menu_item, :calendar)
        |> assign(:title, page.title)
        |> render(
          "show.html",
          category: page.category,
          page: page,
          changeset: changeset,
          participants: participants,
          participant: participant,
          message: message(prefix, page)
        )
    end
  end

  defp participant(prefix, conn, page) do
    case conn.assigns.current_user do
      nil -> false
      _ -> Events.get_participant(prefix, page.id, conn.assigns.current_user.id)
    end
  end

  defp message(prefix, page) do
    case page.signup_to_event do
      true ->
        {:ok, message} =
          System.find_or_create_message(
            prefix,
            "Signup to event",
            "Signup to event",
            Gettext.get_locale()
          )

        message

      _ ->
        ""
    end
  end
end
