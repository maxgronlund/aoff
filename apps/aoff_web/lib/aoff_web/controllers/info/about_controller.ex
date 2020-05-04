defmodule AOFFWeb.Info.AboutController do
  use AOFFWeb, :controller

  alias AOFF.Blogs

  def show(conn, %{"info_id" => blog_id, "id" => id}) do
    conn = assign(conn, :page, :about_aoff)
    post = Blogs.get_post!(blog_id, id)
    render(conn, "show.html", post: post, blog: post.blog)
  end
end
