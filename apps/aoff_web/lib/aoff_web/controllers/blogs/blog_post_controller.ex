defmodule AOFFWeb.Blogs.BlogPostController do
  use AOFFWeb, :controller

  alias AOFF.Blogs

  def show(conn, %{"blog_id" => blog_id, "id" => id}) do
    post = Blogs.get_post!(blog_id, id)
    render(conn, "show.html", post: post, blog: post.blog)
  end
end
