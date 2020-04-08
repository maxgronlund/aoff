defmodule AOFF.Users.OrderFixture do
  alias AOFF.Users

  @create_attrs %{
    "state" => "pending"
  }

  @update_attrs %{
    "state" => "closed",
    "payment_date" => Date.utc_today()
  }

  @invalid_attrs %{
    "state" => nil
  }

  def create_order_attrs(attrs \\ %{}) do
    Enum.into(@create_attrs, attrs)
  end

  def update_order_attrs(attrs \\ %{}) do
    Enum.into(@update_attrs, attrs)
  end

  def invalid_order_attrs(attrs \\ %{}) do
    Enum.into(@invalid_attrs, attrs)
  end

  def order_fixture(user_id, attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(@create_attrs)
      |> Map.put("user_id", user_id)
      |> Users.create_order()

    order
  end
end
