defmodule AOFF.BlogsTest do
  use AOFF.DataCase

  import AOFF.Blogs.BlogFixture

  alias AOFF.Blogs

  describe "blogs" do
    alias AOFF.Blogs.Blog

    test "list_blogs/0 returns all blogs" do
      blog = blog_fixture()
      assert Blogs.list_blogs() == [blog]
    end

    test "get_blog!/1 returns the blog with given id" do
      blog = blog_fixture()
      assert Blogs.get_blog!(blog.id).id == blog.id
    end

    test "create_blog/1 with valid data creates a blog" do
      attrs = create_blog_attrs()
      assert {:ok, %Blog{} = blog} = Blogs.create_blog(attrs)
      assert blog.description == attrs["description"]
      assert blog.title == attrs["title"]
    end

    test "create_blog/1 with invalid data returns error changeset" do
      attrs = invalid_blog_attrs()
      assert {:error, %Ecto.Changeset{}} = Blogs.create_blog(attrs)
    end

    test "update_blog/2 with valid data updates the blog" do
      blog = blog_fixture()
      attrs = update_blog_attrs()
      assert {:ok, %Blog{} = blog} = Blogs.update_blog(blog, attrs)
      assert blog.description == "some updated description"
      assert blog.title == "some updated title"
    end

    test "update_blog/2 with invalid data returns error changeset" do
      blog = blog_fixture()
      attrs = invalid_blog_attrs()
      assert {:error, %Ecto.Changeset{}} = Blogs.update_blog(blog, attrs)
      assert blog.title == Blogs.get_blog!(blog.id).title
    end

    test "delete_blog/1 deletes the blog" do
      blog = blog_fixture()
      assert {:ok, %Blog{}} = Blogs.delete_blog(blog)
      assert Blogs.get_blog!(blog.id) == nil
    end

    test "change_blog/1 returns a blog changeset" do
      blog = blog_fixture()
      assert %Ecto.Changeset{} = Blogs.change_blog(blog)
    end
  end
end
