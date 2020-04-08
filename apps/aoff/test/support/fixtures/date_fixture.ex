defmodule AOFF.Shop.DateFixture do
  alias AOFF.Shop

  @valid_attrs %{
    "date" => Date.add(Date.utc_today(), 365)
  }

  @update_attrs %{
    "date" => Date.add(Date.utc_today(), 165)
  }

  @invalid_attrs %{
    "date" => nil
  }

  def valid_date_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@valid_attrs)
  end

  def update_date_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@update_attrs)
  end

  def invalid_date_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@invalid_attrs)
  end

  def date_fixture(attrs \\ %{}) do
    {:ok, date} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Shop.create_date()

    date
  end
end
