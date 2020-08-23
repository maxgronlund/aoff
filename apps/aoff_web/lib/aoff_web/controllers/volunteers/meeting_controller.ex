defmodule AOFFWeb.Volunteer.MeetingController do
  use AOFFWeb, :controller

  alias AOFF.Committees
  alias AOFF.Committees.Meeting

  alias AOFFWeb.Users.Auth
  alias AOFF.Users
  plug Auth
  plug :authenticate when action in [:index, :edit, :new, :update, :create, :delete]

  def new(conn, %{"committee_id" => committee_id}) do
    committee = Committees.get_committee!(committee_id)
    changeset = Committees.change_meeting(%Meeting{date: Date.add(Date.utc_today(), 14)})

    render(
      conn,
      "new.html",
      changeset: changeset,
      committee: committee,
      users: list_volunteers()
    )
  end

  def create(conn, %{"meeting" => meeting_params}) do
    committee = Committees.get_committee!(meeting_params["committee_id"])

    case Committees.create_meeting(meeting_params) do
      {:ok, meeting} ->
        conn
        |> put_flash(:info, gettext("Meeting created successfully."))
        |> redirect(to: Routes.committee_committee_meeting_path(conn, :show, committee, meeting))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, committee: committee)
    end
  end

  def edit(conn, %{"id" => id}) do
    meeting = Committees.get_meeting!(id)
    changeset = Committees.change_meeting(meeting)

    render(
      conn,
      "edit.html",
      committee: meeting.committee,
      meeting: meeting,
      changeset: changeset,
      users: list_volunteers()
    )
  end

  def update(conn, %{"id" => id, "meeting" => meeting_params}) do
    meeting = Committees.get_meeting!(id)

    case Committees.update_meeting(meeting, meeting_params) do
      {:ok, meeting} ->
        conn
        |> put_flash(:info, gettext("Meeting updated successfully."))
        |> redirect(
          to: Routes.committee_committee_meeting_path(conn, :show, meeting.committee, meeting)
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", meeting: meeting, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    meeting = Committees.get_meeting!(id)
    {:ok, _meeting} = Committees.delete_meeting(meeting)

    conn
    |> put_flash(:info, gettext("Meeting deleted successfully."))
    |> redirect(to: Routes.committee_committee_path(conn, :show, meeting.committee_id))
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.volunteer do
      assign(conn, :selected_menu_item, :volunteer)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end

  defp list_volunteers() do
    Enum.map(Users.list_volunteers(), fn u -> {u.username, u.id} end)
  end
end
