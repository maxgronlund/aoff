defmodule AOFF.Users.OrderItemTest do
  use AOFF.DataCase

  alias AOFF.Users

  import AOFF.Users.UserFixture
  import AOFF.Users.OrderFixture
  import AOFF.Users.OrderItemFixture
  import AOFF.Shop.DateFixture
  import AOFF.Shop.ProductFixture
  import AOFF.Shop.PickUpFixture

  describe "order_items" do
    alias AOFF.Users.OrderItem

    setup do
      user = user_fixture()
      order = order_fixture(user.id)
      date = date_fixture()
      product = product_fixture()
      pick_up =
        pick_up_fixture(%{
          "date_id" => date.id,
          "user_id" => user.id,
          "username" => user.username,
          "member_nr" => user.member_nr,
          "order_id" => order.id,
          "email" => user.email,
          "price" => product.price
        })

      {:ok, user: user, product: product, order: order, pick_up: pick_up, date: date}
    end

    # test "list_order_items/0 returns all order_items", %{user: user, order: order} do
    #   order_item = order_fixture(user.id, %{"order_id" => order.id})
    #   assert Users.list_order_items() == [order_item]
    # end

    test "get_order_item!/1 returns the order_item with given id",
         %{user: user, product: product, order: order, pick_up: pick_up, date: date} do
      order_item =
        order_item_fixture(%{
          "order_id" => order.id,
          "product_id" => product.id,
          "user_id" => user.id,
          "pick_up_id" => pick_up.id,
          "date_id" => date.id,
          "price" => product.price
        })

      assert Users.get_order_item!(order_item.id).id == order_item.id
    end

    test "create_order_item/1 with valid data creates a order_item",
         %{user: user, product: product, order: order, pick_up: pick_up, date: date} do

      attrs =
        valid_order_item_attrs(%{
          "order_id" => order.id,
          "product_id" => product.id,
          "user_id" => user.id,
          "pick_up_id" => pick_up.id,
          "date_id" => date.id,
          "price" => product.price
        })

      assert {:ok, %OrderItem{} = order_item} = Users.create_order_item(attrs, "public")
      assert order_item.order_id == order.id
    end

    test "create_order_item/1 with invalid data returns error changeset" do
      attrs = invalid_order_item_attrs()
      assert {:error, %Ecto.Changeset{}} = Users.create_order_item(attrs)
    end

    test "delete_order_item/1 deletes the order_item",
         %{user: user, product: product, order: order, pick_up: pick_up, date: date} do
      order_item =
        order_item_fixture(%{
          "order_id" => order.id,
          "product_id" => product.id,
          "user_id" => user.id,
          "pick_up_id" => pick_up.id,
          "date_id" => date.id,
          "price" => product.price
        })

      assert {:ok, %OrderItem{}} = Users.delete_order_item(order_item, "public")
      assert_raise Ecto.NoResultsError, fn -> Users.get_order_item!(order_item.id) end
    end

    test "change_order_item/1 returns a order_item changeset",
         %{user: user, product: product, order: order, pick_up: pick_up, date: date} do
      order_item =
        order_item_fixture(%{
          "order_id" => order.id,
          "product_id" => product.id,
          "user_id" => user.id,
          "pick_up_id" => pick_up.id,
          "date_id" => date.id,
          "price" => product.price
        })

      assert %Ecto.Changeset{} = Users.change_order_item(order_item)
    end
  end
end
