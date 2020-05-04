defmodule AOFFWeb.InfoController do
  use AOFFWeb, :controller

  alias AOFF.Blogs
  alias AOFF.System

  def index(conn, _params) do
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

    blogs = Blogs.all_but_news(Gettext.get_locale())
    # {:ok, manufacturers} = Blogs.find_or_create_blog("manufacturers", Gettext.get_locale())
    # {:ok, calendar} = Blogs.find_or_create_blog("calendar", Gettext.get_locale())
    # {:ok, about_aoff} = Blogs.find_or_create_blog("about_aoff", Gettext.get_locale())

    render(conn, "index.html",
      message: message,
      blogs: blogs,
      committees: committees
    )
  end

  def show(conn, %{"id" => id}) do
    conn = assign(conn, :page, :about_aoff)
    blog = Blogs.get_blog!(id)

    render(conn, "show.html", blog: blog)


  end
end
