defmodule AOFF.Committees.MessageFixture do
  @valid_attrs %{
    "body" => "some body",
    "title" => "some title",
    "from" => "from someone"
  }

  # @update_attrs %{
  #   "body" => "some updated body",
  #   "title" => "some updated title"
  # }

  @invalid_attrs %{
    "body" => nil,
    "title" => nil,
    "from" => nil
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
    {:ok, message} = AOFF.Committees.create_message("public", Enum.into(attrs, @valid_attrs))

    message
  end
end
