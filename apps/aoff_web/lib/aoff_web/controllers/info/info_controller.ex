defmodule AOFFWeb.InfoController do
  use AOFFWeb, :controller

  alias AOFF.Blogs
  alias AOFF.System

  def index(conn, _params) do
    blogs = Blogs.all_but_news(Gettext.get_locale())
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

  def show(conn, %{"id" => id}) do
    if blog = Blogs.get_blog!(id) do
      conn = assign(conn, :page, :about_aoff)
      render(conn, "show.html", blog: blog)
    else
      conn
      |> redirect(to: Routes.info_path(conn, :index))
    end
  end

  def show(conn, _params) do
    conn
    |> redirect(to: Routes.info_path(conn, :index))
  end
end
