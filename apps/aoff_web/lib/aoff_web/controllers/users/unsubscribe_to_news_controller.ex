defmodule AOFFWeb.Users.UnsubscribeToNewsController do
  use AOFFWeb, :controller
  alias AOFF.Users

  def show(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix

    case Users.get_user_by_unsubscribe_to_news_token(prefix, id) do
      %AOFF.Users.User{} = user ->
        {:ok, %AOFF.Users.User{} = user} = Users.unsubscribe_to_news(user)
        render(conn, "show.html", user: user)

      _ ->
        not_found(conn)
    end
  end

  defp not_found(conn) do
    conn
    |> put_status(401)
    |> put_view(AOFFWeb.ErrorView)
    |> render(:"401")
    |> halt()
  end
end
