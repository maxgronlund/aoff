defmodule AOFFWeb.Volunteer.NewsController do
  use AOFFWeb, :controller

  alias AOFF.Content
  alias AOFF.Content.News

  alias AOFFWeb.Users.Auth
  alias AOFF.System
  plug Auth
  plug :authenticate when action in [:edit, :new, :update, :create, :delete]
  plug :navbar when action in [:new, :edit]

  def new(conn, _params) do
    changeset = Content.change_news(%News{})

    render(
      conn,
      "new.html",
      changeset: changeset,
      author: conn.assigns.current_user.username,
      date: Date.utc_today(),
      news: false
    )
  end

  def create(conn, %{"news" => news_params}) do
    case Content.create_news(news_params) do
      {:ok, news} ->
        conn
        |> put_flash(:info, gettext("News created successfully."))
        |> redirect(to: Routes.volunteer_news_path(conn, :edit, news))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          date: news_params["date"],
          author: news_params["author"],
          image_format: image_format,
          news: false
        )
    end
  end

  def edit(conn, %{"id" => id}) do
    news = Content.get_news!(id)
    changeset = Content.change_news(news)
    render(
      conn,
      "edit.html",
      news: news,
      changeset: changeset,
      date: news.date,
      author: news.author,
      image_format: image_format
    )
  end

  def update(conn, %{"id" => id, "news" => news_params}) do
    news = Content.get_news!(id)

    case Content.update_news(news, news_params) do
      {:ok, news} ->
        conn
        |> put_flash(:info, gettext("News updated successfully."))
        |> redirect(to: Routes.news_path(conn, :show, news))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn, "edit.html",
          news: news,
          changeset: changeset,
          date: news_params["date"],
          author: news_params["author"],
          image_format: image_format
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    news = Content.get_news!(id)
    {:ok, _news} = Content.delete_news(news)

    conn
    |> put_flash(:info, gettext("News deleted successfully."))
    |> redirect(to: Routes.news_path(conn, :index))
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.volunteer do
      conn
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end

  defp navbar(conn, _opts) do
    assign(conn, :page, :volunteer)
  end

  defp image_format() do
    {:ok, message} =
      System.find_or_create_message(
        "/volunteer/blogs/:id/edit",
        "Image format",
        Gettext.get_locale()
      )

    message
  end
end
