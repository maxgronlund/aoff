defmodule AOFF.Volunteer.NewsletterTest do
  use AOFF.DataCase
  import AOFF.Volunteer.NewsletterFixture

  alias AOFF.Volunteers
  alias AOFF.Volunteer.Newsletter

  describe "newsletters" do
    test "list_newsletters/0 returns all newsletters" do
      newsletter = newsletter_fixture()
      assert Volunteers.list_newsletters("public") == [newsletter]
    end

    test "get_newsletter!/1 returns the newsletter with given id" do
      newsletter = newsletter_fixture()
      assert Volunteers.get_newsletter!(newsletter.id, "public") == newsletter
    end

    test "create_newsletter/1 with valid data creates a newsletter" do
      attrs = valid_newsletter_attrs()
      assert {:ok, %Newsletter{} = newsletter} = Volunteers.create_newsletter(attrs, "public")
      assert newsletter.author == attrs["author"]
      assert newsletter.caption == attrs["caption"]
      assert newsletter.date == attrs["date"]
      assert newsletter.send == attrs["send"]
      assert newsletter.text == attrs["text"]
      assert newsletter.title == attrs["title"]
    end

    test "create_newsletter/1 with invalid data returns error changeset" do
      invalid_attrs = invalid_newsletter_attrs()
      assert {:error, %Ecto.Changeset{}} = Volunteers.create_newsletter(invalid_attrs, "public")
    end

    test "update_newsletter/2 with valid data updates the newsletter" do
      attrs = update_newsletter_attrs()
      newsletter = newsletter_fixture()
      assert {:ok, %Newsletter{} = newsletter} = Volunteers.update_newsletter(newsletter, attrs)
      assert newsletter.author == attrs["author"]
      assert newsletter.caption == attrs["caption"]
      assert newsletter.date == attrs["date"]
      assert newsletter.send == attrs["send"]
      assert newsletter.text == attrs["text"]
      assert newsletter.title == attrs["title"]
    end

    test "update_newsletter/2 with invalid data returns error changeset" do
      newsletter = newsletter_fixture()
      invalid_attrs = invalid_newsletter_attrs()
      assert {:error, %Ecto.Changeset{}} = Volunteers.update_newsletter(newsletter, invalid_attrs)
      assert newsletter == Volunteers.get_newsletter!(newsletter.id, "public")
    end

    test "delete_newsletter/1 deletes the newsletter" do
      newsletter = newsletter_fixture()
      assert {:ok, %Newsletter{}} = Volunteers.delete_newsletter(newsletter)
      assert_raise Ecto.NoResultsError, fn -> Volunteers.get_newsletter!(newsletter.id, "public") end
    end

    test "newsletter_send/1 update the send field" do
      newsletter = newsletter_fixture()
      assert {:ok, %Newsletter{send: true}} = Volunteers.newsletter_send(newsletter)
    end

    test "change_newsletter/1 returns a newsletter changeset" do
      newsletter = newsletter_fixture()
      assert %Ecto.Changeset{} = Volunteers.change_newsletter(newsletter)
    end
  end
end
