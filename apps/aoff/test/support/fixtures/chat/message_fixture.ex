defmodule AOFF.Chat.MessageFixture do
  @valid_attrs %{
    "body" => "some body",
    "username" => "some username",
    "posted_at" => DateTime.utc_now(),
    "posted" => "19. maj 2020"
  }

  @update_attrs %{
    "body" => "some body",
    "username" => "some username",
    "posted_at" => DateTime.utc_now(),
    "posted" => "20. maj 2020"
  }

  @invalid_attrs %{
    "body" => nil,
    "username" => nil,
    "posted_at" => nil,
    "posted" => nil
  }

  def valid_message_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(@valid_attrs)
  end

  def update_message_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(@update_attrs)
  end

  def invalid_message_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(@invalid_attrs)
  end

  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(@valid_attrs)
      |> AOFF.Chats.create_message()

    message
  end
end
