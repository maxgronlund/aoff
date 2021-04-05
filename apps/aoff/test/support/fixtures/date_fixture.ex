defmodule AOFF.Shop.DateFixture do
  alias AOFF.Shop

  @valid_attrs %{
    "date" => Date.add(Date.utc_today(), 365),
    "last_order_date" => Date.add(Date.utc_today(), 362)
  }

  @update_attrs %{
    "date" => Date.add(Date.utc_today(), 165),
    "last_order_date" => Date.add(Date.utc_today(), 162)
  }

  @invalid_attrs %{
    "date" => nil,
    "last_order_date" => nil
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
    {:ok, date} = Shop.create_date("public", Enum.into(attrs, @valid_attrs))

    date
  end
end
