defmodule AOFF.Volunteer.NewsletterFixture do
  alias AOFF.Volunteers

  @valid_attrs %{
    "author" => "some author",
    "caption" => "some caption",
    "date" => Date.add(Date.utc_today(), 1),
    "send" => false,
    "text" => "some text",
    "title" => "some title"
  }

  @update_attrs %{
    "author" => "some updated author",
    "caption" => "some updated caption",
    "date" => Date.add(Date.utc_today(), 5),
    "send" => false,
    "text" => "some updated text",
    "title" => "some updated title"
  }

  @invalid_attrs %{
    "author" => nil,
    "caption" => nil,
    "date" => nil,
    "send" => nil,
    "text" => nil,
    "title" => nil
  }

  def valid_newsletter_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@valid_attrs)
  end

  def update_newsletter_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@update_attrs)
  end

  def invalid_newsletter_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@invalid_attrs)
  end

  def newsletter_fixture(attrs \\ %{}) do
    {:ok, newsletter} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Volunteers.create_newsletter()

    newsletter
  end
end
