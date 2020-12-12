defmodule AOFF.Users.OrderFixture do
  alias AOFF.Users

  @create_attrs %{
    "state" => "open"
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
    attrs =
      attrs
      |> Enum.into(@create_attrs)
      |> Map.put("user_id", user_id)

    {:ok, order} = Users.create_order("public", attrs)

    order
  end
end
