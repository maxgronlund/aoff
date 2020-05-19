defmodule AOFFWeb.Content.AboutController do
  use AOFFWeb, :controller

  # alias AOFF.Content
  # alias AOFF.Content.News

  alias AOFF.Blogs
  alias AOFF.System
  alias AOFF.Content

  def index(conn, _params) do
    blogs = Content.list_categories()
    conn = assign(conn, :page, :about_aoff)

    {:ok, message} =
      System.find_or_create_message(
        "/info",
        "Info",
        Gettext.get_locale()
      )

    {:ok, committees} =
      System.find_or_create_message(
        "/info - committees",
        "Committees",
        Gettext.get_locale()
      )

    render(conn, "index.html",
      message: message,
      blogs: blogs,
      committees: committees
    )
  end

  # def new(conn, _params) do
  #   changeset = Content.change_news(%News{})
  #   render(conn, "new.html", changeset: changeset)
  # end

  # def create(conn, %{"news" => news_params}) do
  #   case Content.create_news(news_params) do
  #     {:ok, news} ->
  #       conn
  #       |> put_flash(:info, "News created successfully.")
  #       |> redirect(to: Routes.news_path(conn, :show, news))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

  def show(conn, %{"id" => id}) do
    category = Content.get_category!(id)
    render(conn, "show.html", category: category)
  end

  # def edit(conn, %{"id" => id}) do
  #   news = Content.get_news!(id)
  #   changeset = Content.change_news(news)
  #   render(conn, "edit.html", news: news, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "news" => news_params}) do
  #   news = Content.get_news!(id)

  #   case Content.update_news(news, news_params) do
  #     {:ok, news} ->
  #       conn
  #       |> put_flash(:info, "News updated successfully.")
  #       |> redirect(to: Routes.news_path(conn, :show, news))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", news: news, changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   news = Content.get_news!(id)
  #   {:ok, _news} = Content.delete_news(news)

  #   conn
  #   |> put_flash(:info, "News deleted successfully.")
  #   |> redirect(to: Routes.news_path(conn, :index))
  # end
end
