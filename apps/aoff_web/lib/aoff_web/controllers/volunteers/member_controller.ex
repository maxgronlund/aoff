defmodule AOFFWeb.Volunteer.MemberController do
  use AOFFWeb, :controller

  alias AOFF.Committees
  alias AOFF.Committees.Member
  alias AOFF.Users

  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:edit, :new, :update, :create, :delete]


  def index(conn, %{"committee_id" => committee_id}) do
    committee = Committees.get_committee!(committee_id)
    members = Committees.list_members()
    render(conn, "index.html", committee: committee, members: members)
  end

  def new(conn, %{"committee_id" => committee_id}) do
    committee = Committees.get_committee!(committee_id)
    changeset = Committees.change_member(%Member{})

    render(conn, "new.html",
      changeset: changeset,
      committee: committee,
      users: list_volunteers()
    )
  end

  def create(conn, %{"member" => member_params}) do
    case Committees.create_member(member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, gettext("Member created successfully."))
        |> redirect(to: Routes.volunteer_committee_path(conn, :show, member.committee_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        committee = Committees.get_committee!(member_params["committee_id"])

        render(conn, "new.html",
          changeset: changeset,
          committee: committee,
          users: list_volunteers()
        )
    end
  end

  def show(conn, %{"id" => id}) do
    member = Committees.get_member!(id)
    render(conn, "show.html", member: member)
  end

  def edit(conn, %{"id" => id}) do
    member = Committees.get_member!(id)
    changeset = Committees.change_member(member)

    render(conn, "edit.html",
      committee: member.committee,
      member: member,
      changeset: changeset,
      users: list_volunteers()
    )
  end

  def update(conn, %{"id" => id, "member" => member_params}) do
    member = Committees.get_member!(id)

    case Committees.update_member(member, member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, gettext("Member updated successfully."))
        |> redirect(to: Routes.committee_committee_path(conn, :show, member.committee_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          member: member,
          committee: member.committee,
          users: list_volunteers(),
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    member = Committees.get_member!(id)
    {:ok, _member} = Committees.delete_member(member)

    conn
    |> put_flash(:info, gettext("Member deleted successfully."))
    |> redirect(to: Routes.committee_committee_path(conn, :show, member.committee_id))
  end

  defp list_volunteers() do
    Enum.map(Users.list_volunteers(), fn u -> {u.username, u.id} end)
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
