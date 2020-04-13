defmodule AOFFWeb.InfoController do
  use AOFFWeb, :controller

  alias AOFF.Blogs
  alias AOFF.System

  def index(conn, _params) do
    conn = assign(conn, :page, :about_aoff)


    {:ok, message } = System.find_or_create_message("/info", Gettext.get_locale())


    {:ok, manufacturers} = Blogs.find_or_create_blog("manufacturers", Gettext.get_locale())
    {:ok, calendar} = Blogs.find_or_create_blog("calendar", Gettext.get_locale())
    {:ok, about_aoff} = Blogs.find_or_create_blog("about_aoff", Gettext.get_locale())


    render(
      conn,
      "index.html",
      message: message,
      manufacturers: manufacturers,
      calendar: calendar,
      about_aoff: about_aoff
    )

  end

  def show(conn, %{"id" => id}) do
    conn = assign(conn, :page, :about_aoff)
    blog = Blogs.get_blog!(id)
    render(conn, "show.html", blog: blog)
  end
end
