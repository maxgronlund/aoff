defmodule AOFF.System.MessageFixture do

  alias AOFF.System.Message


  @valid_attrs %{
    "text" => "some text",
    "identifier" => "some identifier",
    "locale" => "some locale",
    "show" => true,
    "title" => "some title"
  }
  @update_attrs %{
    "text" => "some updated text",
    "identifier" => "some updated identifier",
    "locale" => "some updated locale",
    "show" => false,
    "title" => "some updated title"
  }
  @invalid_attrs %{
    "text" => nil,
    "identifier" => nil,
    "locale" => nil,
    "show" => nil,
    "title" => nil
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
      |> AOFF.System.create_message()
    message
  end
end