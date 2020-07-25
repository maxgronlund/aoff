defmodule AOFFWeb.Volunteer.UserController do
  use AOFFWeb, :controller

  alias AOFF.Volunteers
  alias AOFF.Users
  alias AOFF.Users.User
  alias AOFF.System


  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index, :show, :edit, :update, :delete, :new]

  def index(conn, params) do
    users =
      if query = params["query"] do
        Users.search_users(query)
      else
        page = params["page"] || "0"
        Users.list_users(String.to_integer(page))
      end

    conn
    |> assign(:title, gettext("Admin Users"))
    |> put_session(:shop_assistant_date_id, nil)
    |> render(
        "index.html",
        users: users,
        pages: Users.user_pages(),
        members: Users.member_count(:all),
        valid_members: Users.member_count(:valid)
      )
  end

  def edit(conn, %{"id" => id}) do

    user = Volunteers.get_user!(id)
    changeset = Volunteers.change_user(user)
    conn
    |> assign(:title, gettext("Edit Account"))
    |> render(
      "edit.html",
      user: user,
      changeset: changeset,
      email: user.email,
      cancel_path: redirect_path(conn)
    )
  end

  def new(conn, _params) do
    changeset =
      Users.change_user(%User{
        expiration_date: Date.add(AOFF.Time.today(), 365)
      })

    {:ok, message} =
      System.find_or_create_message(
        "/volunteer/users/new",
        "Create account",
        Gettext.get_locale()
      )

    cancel_path = redirect_path(conn)

    render(
      conn,
      "new.html",
      changeset: changeset,
      email: "",
      message: message,
      user: false,
      cancel_path: cancel_path
    )
  end

  def create(conn, %{"user" => user_params}) do
    user_params = Map.put(user_params, "terms_accepted", true)

    case Volunteers.register_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(
          :info,
          gettext("A membership for %{username} is created", username: user.username)
        )
        |> redirect(to: redirect_path(conn))

      {:error, %Ecto.Changeset{} = changeset} ->
        {:ok, message} =
          System.find_or_create_message(
            "/volunteer/users/new",
            "Create account",
            Gettext.get_locale()
          )

        render(
          conn,
          "new.html",
          changeset: changeset,
          email: user_params["email_confirmation"],
          message: message,
          user: false,
          cancel_path: redirect_path(conn)
        )
    end
  end

  defp redirect_path(conn) do
    case get_session(conn, :shop_assistant_date_id) do
      nil ->
        Routes.volunteer_user_path(conn, :index)
      date_id ->
        Routes.shop_assistant_date_path(conn, :show, date_id)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Volunteers.get_user!(id)
    conn
    |> assign(:title, user.username)
    |> render("show.html", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Volunteers.get_user!(id)

    case Volunteers.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, gettext("User updated successfully."))
        |> redirect(to: Routes.volunteer_user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn,
          "edit.html",
          user: user,
          changeset: changeset,
          email: user.email,
          cancel_path: redirect_path(conn)
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Volunteers.get_user!(id)
    {:ok, _user} = Volunteers.delete_user(user)

    conn
    |> put_flash(:info, gettext("User deleted successfully."))
    |> redirect(to: Routes.volunteer_user_path(conn, :index))
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
end
