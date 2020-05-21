defmodule AOFF.Shop.PickUpTest do
  use AOFF.DataCase

  alias AOFF.Shop

  import AOFF.Users.UserFixture
  import AOFF.Users.OrderFixture
  import AOFF.Users.OrderItemFixture
  import AOFF.Shop.ProductFixture
  import AOFF.Shop.PickUpFixture
  import AOFF.Shop.DateFixture

  def create_pick_up(date, user, order) do
    pick_up_fixture(%{
      "date_id" => date.id,
      "user_id" => user.id,
      "username" => user.username,
      "member_nr" => user.member_nr,
      "order_id" => order.id,
      "email" => user.email
    })
  end

  describe "pick_ups" do
    alias AOFF.Shop.PickUp

    setup do
      date = date_fixture()
      user = user_fixture()
      order = order_fixture(user.id)

      {:ok, date: date, user: user, order: order}
    end

    test "list_pick_ups/0 returns all pick_ups", %{date: date, user: user, order: order} do
      pick_up = create_pick_up(date, user, order)
      product = product_fixture()

      order_item_fixture(%{
        "product_id" => product.id,
        "user_id" => user.id,
        "date_id" => date.id,
        "pick_up_id" => pick_up.id,
        "price" => product.price,
        "order_id" => order.id
      })

      assert List.first(Shop.list_pick_ups(date.id)).id == pick_up.id
    end

    test "get_pick_up!/1 returns the pick_up with given id", %{
      date: date,
      user: user,
      order: order
    } do
      pick_up = create_pick_up(date, user, order)
      assert Shop.get_pick_up!(pick_up.id).id == pick_up.id
    end

    test "create_pick_up/1 with valid data creates a pick_up", %{
      date: date,
      user: user,
      order: order
    } do
      attrs =
        valid_pick_up_attrs(%{
          "date_id" => date.id,
          "user_id" => user.id,
          "username" => user.username,
          "member_nr" => user.member_nr,
          "order_id" => order.id,
          "email" => user.email
        })

      assert {:ok, %PickUp{} = pick_up} = Shop.create_pick_up(attrs)
      assert pick_up.picked_up == attrs["picked_up"]
      assert pick_up.date_id == attrs["date_id"]
      assert pick_up.user_id == attrs["user_id"]
      assert pick_up.username == attrs["username"]
      assert pick_up.member_nr == attrs["member_nr"]
      assert pick_up.email == attrs["email"]
    end

    test "create_pick_up/1 with invalid data returns error changeset" do
      attrs = invalid_pick_up_attrs()
      assert {:error, %Ecto.Changeset{}} = Shop.create_pick_up(attrs)
    end

    test "update_pick_up/2 with valid data updates the pick_up", %{
      date: date,
      user: user,
      order: order
    } do
      pick_up = create_pick_up(date, user, order)
      attrs = update_pick_up_attrs()
      assert {:ok, %PickUp{} = pick_up} = Shop.update_pick_up(pick_up, attrs)
      assert pick_up.picked_up == attrs["picked_up"]
    end

    test "update_pick_up/2 with invalid data returns error changeset", %{
      date: date,
      user: user,
      order: order
    } do
      pick_up = create_pick_up(date, user, order)
      attrs = invalid_pick_up_attrs()
      assert {:error, %Ecto.Changeset{}} = Shop.update_pick_up(pick_up, attrs)
      assert pick_up.id == Shop.get_pick_up!(pick_up.id).id
    end

    test "delete_pick_up/1 deletes the pick_up", %{date: date, user: user, order: order} do
      pick_up = create_pick_up(date, user, order)
      assert {:ok, %PickUp{}} = Shop.delete_pick_up(pick_up)
      assert_raise Ecto.NoResultsError, fn -> Shop.get_pick_up!(pick_up.id) end
    end

    test "change_pick_up/1 returns a pick_up changeset", %{date: date, user: user, order: order} do
      pick_up = create_pick_up(date, user, order)
      assert %Ecto.Changeset{} = Shop.change_pick_up(pick_up)
    end
  end
end
