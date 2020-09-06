defmodule AOFF.NewsletterTest do
  use AOFF.DataCase

  alias AOFF.Volunteer

  describe "newsletters" do
    alias AOFF.Volunteer.NewsLetter

    @valid_attrs %{
      author: "some author",
      caption: "some caption",
      date: ~D[2010-04-17],
      image: "some image",
      send: true,
      text: "some text",
      title: "some title"
    }
    @update_attrs %{
      author: "some updated author",
      caption: "some updated caption",
      date: ~D[2011-05-18],
      image: "some updated image",
      send: false,
      text: "some updated text",
      title: "some updated title"
    }
    @invalid_attrs %{
      author: nil,
      caption: nil,
      date: nil,
      image: nil,
      send: nil,
      text: nil,
      title: nil
    }

    def newsletter_fixture(attrs \\ %{}) do
      {:ok, newsletter} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Volunteer.create_newsletter()

      newsletter
    end

    test "list_newsletters/0 returns all newsletters" do
      newsletter = newsletter_fixture()
      assert Volunteer.list_newsletters() == [newsletter]
    end

    test "get_newsletter!/1 returns the newsletter with given id" do
      newsletter = newsletter_fixture()
      assert Volunteer.get_newsletter!(newsletter.id) == newsletter
    end

    test "create_newsletter/1 with valid data creates a newsletter" do
      assert {:ok, %NewsLetter{} = newsletter} = Volunteer.create_newsletter(@valid_attrs)
      assert newsletter.author == "some author"
      assert newsletter.caption == "some caption"
      assert newsletter.date == ~D[2010-04-17]
      assert newsletter.image == "some image"
      assert newsletter.send == true
      assert newsletter.text == "some text"
      assert newsletter.title == "some title"
    end

    test "create_newsletter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Volunteer.create_newsletter(@invalid_attrs)
    end

    test "update_newsletter/2 with valid data updates the newsletter" do
      newsletter = newsletter_fixture()

      assert {:ok, %NewsLetter{} = newsletter} =
               Volunteer.update_newsletter(newsletter, @update_attrs)

      assert newsletter.author == "some updated author"
      assert newsletter.caption == "some updated caption"
      assert newsletter.date == ~D[2011-05-18]
      assert newsletter.image == "some updated image"
      assert newsletter.send == false
      assert newsletter.text == "some updated text"
      assert newsletter.title == "some updated title"
    end

    test "update_newsletter/2 with invalid data returns error changeset" do
      newsletter = newsletter_fixture()
      assert {:error, %Ecto.Changeset{}} = Volunteer.update_newsletter(newsletter, @invalid_attrs)
      assert newsletter == Volunteer.get_newsletter!(newsletter.id)
    end

    test "delete_newsletter/1 deletes the newsletter" do
      newsletter = newsletter_fixture()
      assert {:ok, %NewsLetter{}} = Volunteer.delete_newsletter(newsletter)
      assert_raise Ecto.NoResultsError, fn -> Volunteer.get_newsletter!(newsletter.id) end
    end

    test "change_newsletter/1 returns a newsletter changeset" do
      newsletter = newsletter_fixture()
      assert %Ecto.Changeset{} = Volunteer.change_newsletter(newsletter)
    end
  end
end
