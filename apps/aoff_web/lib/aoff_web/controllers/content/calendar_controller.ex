defmodule AOFFWeb.Content.CalendarController do
  use AOFFWeb, :controller

  alias AOFF.Content
  alias AOFF.System
  alias AOFF.Events
  alias AOFF.Events.Participant

  def index(conn, params) do
    {:ok, calendar} = Content.find_or_create_category("Calendar")

    {:ok, message} =
      System.find_or_create_message(
        "Calendar",
        "Calendar",
        Gettext.get_locale()
      )

    conn
    |> assign(:selected_menu_item, :calendar)
    |> render("index.html", calendar: calendar, message: message)
  end

  def show(conn, %{"id" => id}) do
    case Content.get_page!("Calendar", id) do
      nil ->
        conn
        |> put_flash(:info, gettext("Language updated"))
        |> redirect(to: Routes.about_path(conn, :index))

      page ->
        participants = Events.list_participants(:all, page.id)

        user_ids = Enum.map(participants, fn participant -> participant.user_id end)

        participant = participant(conn, page)

        changeset =
          case conn.assigns.current_user do
            %AOFF.Users.User{} = user ->
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
          message: message(page)
        )
    end
  end

  defp participant(conn, page) do
    case conn.assigns.current_user do
      nil -> false
      _ -> Events.get_participant(page.id, conn.assigns.current_user.id)
    end
  end

  defp message(page) do
    case page.signup_to_event do
      true ->
        {:ok, message} =
          System.find_or_create_message(
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
