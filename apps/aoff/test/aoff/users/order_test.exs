defmodule AOFF.Users.OrderTest do
  use AOFF.DataCase
  import AOFF.Users.OrderFixture
  import AOFF.Users.UserFixture

  alias AOFF.Users

  describe "orders" do
    alias AOFF.Users.Order

    # @valid_attrs %{state: "some state", user_id: "some user_id"}
    # @update_attrs %{state: "some updated state", user_id: "some updated user_id"}
    # @invalid_attrs %{state: nil, user_id: nil}

    # def order_fixture(attrs \\ %{}) do
    #   {:ok, order} =
    #     attrs
    #     |> Enum.into(@valid_attrs)
    #     |> Users.create_order()

    #   order
    # end
    setup do
      user = user_fixture()
      {:ok, user: user}
    end

    test "current_order/1 returns a order when there is no orders", %{user: user} do
      assert %Order{} = Users.current_order(user.id)
    end

    test "list_orders/0 returns all orders", %{user: user} do
      order = order_fixture(user.id)
      Users.payment_accepted(order)
      assert List.last(Users.list_orders(user.id)).id == order.id
    end

    test "get_order!/1 returns the order with given id", %{user: user} do
      order = order_fixture(user.id)
      assert Users.get_order!(order.id).id == order.id
    end

    test "create_order/1 with valid data creates a order", %{user: user} do
      attrs = create_order_attrs(%{"user_id" => user.id})
      assert {:ok, %Order{} = order} = Users.create_order(attrs)
      assert order.state == attrs["state"]
    end

    test "update_order/2 with valid data updates the order", %{user: user} do
      order = order_fixture(user.id)
      attrs = update_order_attrs()
      assert {:ok, %Order{} = order} = Users.update_order(order, attrs)
      assert order.state == attrs["state"]
    end

    test "update_order/2 with invalid data returns error changeset", %{user: user} do
      order = order_fixture(user.id)
      attrs = invalid_order_attrs(%{"user_id" => user.id})
      assert {:error, %Ecto.Changeset{}} = Users.update_order(order, attrs)
      assert order.id == Users.get_order!(order.id).id
    end

    test "change_order/1 returns a order changeset", %{user: user} do
      order = order_fixture(user.id)
      assert %Ecto.Changeset{} = Users.change_order(order)
    end

    test "create_order/0 returns an order without an order id", %{user: user} do
      order = order_fixture(user.id)
      assert order.order_id == ""
    end
  end
end
