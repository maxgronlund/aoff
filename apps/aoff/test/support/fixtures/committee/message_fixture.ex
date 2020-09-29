defmodule AOFF.Committees.MessageFixture do

  @valid_attrs %{
    "body" => "some body",
    "title" => "some title",
    "username" => "some username"
  }

  # @update_attrs %{
  #   "body" => "some updated body",
  #   "title" => "some updated title"
  # }

  @invalid_attrs %{
    "body" => nil,
    "title" => nil,
    "username" => nil
  }

  def valid_message_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(@valid_attrs)
  end

  # def update_message_attrs(attrs \\ %{}) do
  #   attrs
  #   |> Enum.into(@update_attrs)
  # end

  def invalid_message_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(@invalid_attrs)
  end

  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(@valid_attrs)
      |> AOFF.Committees.create_message()

    message
  end
end
