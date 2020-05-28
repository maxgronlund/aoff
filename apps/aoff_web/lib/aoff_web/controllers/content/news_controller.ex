defmodule AOFFWeb.Content.NewsController do
  use AOFFWeb, :controller

  alias AOFF.Content

  def index(conn, _params) do
    news_list = Content.list_news()

    assign(conn, :selected_menu_item, :news)
    |> render("index.html", news_list: news_list)
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
    case Content.get_news!(id) do
      %AOFF.Content.News{} = news ->
        assign(conn, :selected_menu_item, :news)
        |> render("show.html", news: news)

      _ ->
        conn
        |> put_flash(:info, "Language updated")
        |> redirect(to: Routes.news_path(conn, :index))
    end
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
