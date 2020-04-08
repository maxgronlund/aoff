defmodule AOFF.Vulenteers.PostsTest do
  use AOFF.DataCase

  import AOFF.Blogs.BlogPostFixture
  import AOFF.Blogs.BlogFixture

  alias AOFF.Blogs.BlogPost
  alias AOFF.Blogs

  describe "posts" do
    setup do
      blog = blog_fixture()
      {:ok, blog: blog}
    end

    test "list_posts/0 returns all posts", %{blog: blog} do
      post = post_fixture(blog.id)
      assert Blogs.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id", %{blog: blog} do
      post = post_fixture(blog.id)
      assert Blogs.get_post!(post.id).id == post.id
    end

    test "create_post/1 with valid data creates a post", %{blog: blog} do
      attrs = create_post_attrs(%{"blog_id" => blog.id})

      assert {:ok, %BlogPost{} = post} = Blogs.create_post(attrs)
      assert post.author == attrs["author"]
      assert post.caption == attrs["caption"]
      assert post.date == attrs["date"]
      assert post.text == attrs["text"]
      assert post.title == attrs["title"]
    end

    test "create_post/1 with invalid data returns error changeset", %{blog: blog} do
      attrs = invalid_post_attrs(%{"blog_id" => blog.id})
      assert {:error, %Ecto.Changeset{}} = Blogs.create_post(attrs)
    end

    test "update_post/2 with valid data updates the post", %{blog: blog} do
      post = post_fixture(blog.id)
      attrs = update_post_attrs()
      assert {:ok, %BlogPost{} = post} = Blogs.update_post(post, attrs)

      assert post.author == attrs["author"]
      assert post.caption == attrs["caption"]
      assert post.date == attrs["date"]
      assert post.text == attrs["text"]
      assert post.title == attrs["title"]
    end

    test "update_post/2 with invalid data returns error changeset", %{blog: blog} do
      post = post_fixture(blog.id)
      attrs = invalid_post_attrs()
      assert {:error, %Ecto.Changeset{}} = Blogs.update_post(post, attrs)
      assert post.id == Blogs.get_post!(post.id).id
    end

    test "delete_post/1 deletes the post", %{blog: blog} do
      post = post_fixture(blog.id)
      assert {:ok, %BlogPost{}} = Blogs.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blogs.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset", %{blog: blog} do
      post = post_fixture(blog.id)
      assert %Ecto.Changeset{} = Blogs.change_post(post)
    end
  end
end
