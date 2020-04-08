defmodule AOFFWeb.InfoController do
  use AOFFWeb, :controller

  alias AOFF.Blogs

  def index(conn, _params) do
    conn = assign(conn, :page, :info)
    {:ok, news} = Blogs.find_or_create_blog("news", Gettext.get_locale())
    {:ok, manufacturers} = Blogs.find_or_create_blog("manufacturers", Gettext.get_locale())
    {:ok, calendar} = Blogs.find_or_create_blog("calendar", Gettext.get_locale())
    {:ok, about} = Blogs.find_or_create_blog("about", Gettext.get_locale())


    render(
      conn,
      "index.html",
      news: news,
      manufacturers: manufacturers,
      calendar: calendar,
      about: about
    )

  end

  def show(conn, %{"id" => id}) do
    conn = assign(conn, :page, :info)
    blog = Blogs.get_blog!(id)
    render(conn, "show.html", blog: blog)
  end
end
