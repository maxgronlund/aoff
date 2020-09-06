defmodule AOFFWeb.Volunteer.NewsletterControllerTest do
  use AOFFWeb.ConnCase

  alias AOFF.Volunteers

  @create_attrs %{author: "some author", caption: "some caption", date: ~D[2010-04-17], image: "some image", send: true, text: "some text", title: "some title"}
  @update_attrs %{author: "some updated author", caption: "some updated caption", date: ~D[2011-05-18], image: "some updated image", send: false, text: "some updated text", title: "some updated title"}
  @invalid_attrs %{author: nil, caption: nil, date: nil, image: nil, send: nil, text: nil, title: nil}

  def fixture(:newsletter) do
    {:ok, newsletter} = Volunteers.create_newsletter(@create_attrs)
    newsletter
  end

  describe "index" do
    test "lists all newsletters", %{conn: conn} do
      conn = get(conn, Routes.volunteer_newsletter_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Newsletters"
    end
  end

  describe "new newsletter" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.volunteer_newsletter_path(conn, :new))
      assert html_response(conn, 200) =~ "New Newsletter"
    end
  end

  describe "create newsletter" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.volunteer_newsletter_path(conn, :create), newsletter: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.volunteer_newsletter_path(conn, :show, id)

      conn = get(conn, Routes.volunteer_newsletter_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Newsletter"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.volunteer_newsletter_path(conn, :create), newsletter: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Newsletter"
    end
  end

  describe "edit newsletter" do
    setup [:create_newsletter]

    test "renders form for editing chosen newsletter", %{conn: conn, newsletter: newsletter} do
      conn = get(conn, Routes.volunteer_newsletter_path(conn, :edit, newsletter))
      assert html_response(conn, 200) =~ "Edit Newsletter"
    end
  end

  describe "update newsletter" do
    setup [:create_newsletter]

    test "redirects when data is valid", %{conn: conn, newsletter: newsletter} do
      conn = put(conn, Routes.volunteer_newsletter_path(conn, :update, newsletter), newsletter: @update_attrs)
      assert redirected_to(conn) == Routes.volunteer_newsletter_path(conn, :show, newsletter)

      conn = get(conn, Routes.volunteer_newsletter_path(conn, :show, newsletter))
      assert html_response(conn, 200) =~ "some updated author"
    end

    test "renders errors when data is invalid", %{conn: conn, newsletter: newsletter} do
      conn = put(conn, Routes.volunteer_newsletter_path(conn, :update, newsletter), newsletter: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Newsletter"
    end
  end

  describe "delete newsletter" do
    setup [:create_newsletter]

    test "deletes chosen newsletter", %{conn: conn, newsletter: newsletter} do
      conn = delete(conn, Routes.volunteer_newsletter_path(conn, :delete, newsletter))
      assert redirected_to(conn) == Routes.volunteer_newsletter_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.volunteer_newsletter_path(conn, :show, newsletter))
      end
    end
  end

  defp create_newsletter(_) do
    newsletter = fixture(:newsletter)
    %{newsletter: newsletter}
  end
end
