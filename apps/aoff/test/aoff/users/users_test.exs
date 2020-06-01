defmodule AOFF.UsersTest do
  use AOFF.DataCase

  alias AOFF.Users


  import AOFF.Users.UserFixture
  import AOFF.Users.OrderFixture
  import AOFF.Users.OrderItemFixture
  import AOFF.Shop.DateFixture
  import AOFF.Shop.ProductFixture
  import AOFF.Shop.PickUpFixture

  describe "session" do
    test "authenticate_by_email_and_pass/2 when email and pass is valid" do
      _user = user_fixture()
      attrs = valid_attrs()
      assert {:ok, %Users.User{}} =
        Users.authenticate_by_email_and_pass(attrs["email"], attrs["password"])
    end

    test "authenticate_by_email_and_pass/2 when pass is invalid" do
      _user = user_fixture()
      attrs = valid_attrs()
      assert {:error, :unauthorized} ==
        Users.authenticate_by_email_and_pass(attrs["email"], "chunky-becon")
    end

    test "authenticate_by_email_and_pass/2 when email is invalid" do
      _user = user_fixture()
      assert {:error, :not_found} ==
        Users.authenticate_by_email_and_pass("no-one@example.com", "chunky-becon")
    end
  end

  describe "users" do
    alias AOFF.Users.User

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert List.first(Users.list_users()).id == user.id
    end

    test "list_shop_assistans/0 returns all shop_assistans" do
      user = user_fixture(%{"shop_assistans" => true})
      assert List.first(Users.list_users()).id == user.id
    end

    test "get_users_by_username/1 returns the users with the given username" do
      user = user_fixture()

      assert List.first(Users.get_users_by_username(user.username)).id == user.id
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id).id == user.id
    end

    test "get_user_by_email/1 returns the user with given email" do
      user = user_fixture()
      assert Users.get_user_by_email(user.email).id == user.id
    end

    test "search search_users/1 with a valid member_nr" do
      user = user_fixture()
      member_nr = Integer.to_string(user.member_nr)
      assert List.first(Users.search_users(member_nr)).id == user.id
    end

    test "search search_users/1 with a valid email" do
      user = user_fixture()
      assert List.first(Users.search_users(user.email)).id == user.id
    end

    test "search search_users/1 with a valid username" do
      user = user_fixture()
      assert List.first(Users.search_users(user.username)).id == user.id
    end

    test "search search_users/1 with invalid query returns an empty aray" do
      _user = user_fixture()
      assert Users.search_users("XYZ123") == []
    end

    test "create_user/1 with valid data creates a user" do
      attrs = valid_attrs()

      assert {:ok, %User{} = user} = Users.create_user(attrs)

      assert user.username == attrs["username"]
      assert user.email == attrs["email"]
      assert user.mobile == attrs["mobile"]
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(invalid_attrs())
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      attrs = update_attrs(user.id)
      assert {:ok, %User{} = user} = Users.update_user(user, attrs)
      assert user.username == attrs["username"]
      assert user.email == attrs["email"]
      assert user.mobile == attrs["mobile"]
    end

    test "update_user/2 with valid data without password updates the user" do
      user = user_fixture()
      attrs = attrs_without_pass(user.id)
      assert {:ok, %User{} = user} = Users.update_user(user, attrs)
      assert user.username == attrs["username"]
      assert user.email == attrs["email"]
      assert user.mobile == attrs["mobile"]
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      attrs = invalid_attrs()

      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, attrs)
      assert user.id == Users.get_user!(user.id).id
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end

    test "set_bounce_to_url/2 set the bounce_to_url" do
      user = user_fixture()
      some_url = "https://some_url.com/nowhere"
      assert {:ok, %User{} = user} = Users.set_bounce_to_url(user, some_url)
      assert user.bounce_to_url == some_url
    end

    test "get_bounce_to_url/12 gets the bounce_to_url and reset the " do
      user = user_fixture()
      some_url = "https://some_url.com/nowhere"
      assert {:ok, %User{} = user} = Users.set_bounce_to_url(user, some_url)
      assert Users.get_bounce_to_url(user) == some_url
    end

    test "get_order_by_token/1" do
      user = user_fixture()
      order = order_fixture(user.id)
      assert Users.get_order_by_token!(order.token).id == order.id
    end

    test "search order/1 with a valid order_nr" do
      user = user_fixture()
      order = order_fixture(user.id, %{
                "state" => "payment_accepted",
                "order_nr" => 123456789
              })
      order_nr = Integer.to_string(order.order_nr)
      assert List.first(Users.search_orders(order_nr)).id == order.id
    end

    test "search order/1 with a valid username" do
      user = user_fixture()
      order = order_fixture(user.id, %{"state" => "payment_accepted"})
      assert List.first(Users.search_orders(user.username)).id == order.id
    end

    test "search order/1 with a valid email" do
      user = user_fixture()
      order = order_fixture(user.id, %{"state" => "payment_accepted"})
      assert List.first(Users.search_orders(user.email)).id == order.id
    end

    test "search order/1 invalid query returns nil" do
      user = user_fixture()
      _order = order_fixture(user.id)
      assert is_nil(List.first(Users.search_orders("XYZ123")))
    end
  end

  describe "membership" do

    alias AOFF.Users.User
    setup do
      user = user_fixture(%{"expiration_date" => AOFF.Time.today()})
      {:ok, user: user}
    end

    test "extend_memberships/1 extend the membership for a user", %{user: user} do
      expiration_date = user.expiration_date
      product = product_fixture(%{"membership" => true})
      order = order_fixture(user.id)
      date = date_fixture()
      pick_up =
        pick_up_fixture(
          %{
            "date_id" => date.id,
            "user_id" => user.id,
            "order_id" => order.id
          }
        )
      _order_item =
        order_item_fixture(
          %{
            "order_id" => order.id,
            "product_id" => product.id,
            "date_id" => date.id,
            "user_id" => user.id,
            "pick_up_id" => pick_up.id
          }
        )
      order = Users.get_order!(order.id)
      users = Users.extend_memberships(order)
      user = List.first(users)


      assert {:ok, %User{}} = user
      {:ok, user} = user

      assert user.expiration_date == Date.add(expiration_date, 365)
    end
    # test "last_member_nr/0 returne the last member_nr" do
    #   _user = user_fixture()
    #   user = user_fixture(%{"member_nr" => 2})
    #   assert Users.last_member_nr() == user.member_nr
    # end
  end
end
