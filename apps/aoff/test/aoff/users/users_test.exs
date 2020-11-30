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
               Users.authenticate_by_email_and_pass(
                "public",
                 attrs["email"],
                 attrs["password"]
               )
    end

    test "authenticate_by_email_and_pass/2 when pass is invalid" do
      _user = user_fixture()
      attrs = valid_attrs()

      assert {:error, :unauthorized} ==
               Users.authenticate_by_email_and_pass(
                "public",
                 attrs["email"],
                 "chunky-becon"
               )
    end

    test "authenticate_by_email_and_pass/2 when email is invalid" do
      _user = user_fixture()

      assert {:error, :not_found} ==
               Users.authenticate_by_email_and_pass(
                "public",
                 "no-one@example.com",
                 "chunky-becon"
               )
    end
  end

  describe "users" do
    alias AOFF.Users.User

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert List.first(Users.list_users("public")).id == user.id
    end

    test "list_shop_assistans/0 returns all shop_assistans" do
      user = user_fixture(%{"shop_assistans" => true})
      assert List.first(Users.list_users("public")).id == user.id
    end

    test "get_users_by_username/1 returns the users with the given username" do
      user = user_fixture()

      assert List.first(Users.get_users_by_username("public", user.username)).id == user.id
    end

    test "get_user_by_member_nr/1 returns the user with the given member_nr" do
      user = user_fixture()

      assert Users.get_user_by_member_nr("public", user.member_nr).id == user.id
    end

    test "get_user_by_member_nr/1 returns nil" do
      assert is_nil(Users.get_user_by_member_nr("public", -1))
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!("public", user.id).id == user.id
    end

    test "get_user_by_email/1 returns the user with given email" do
      user = user_fixture()
      assert Users.get_user_by_email("public", user.email).id == user.id
    end

    test "search search_users/1 with a valid member_nr" do
      user = user_fixture()
      member_nr = Integer.to_string(user.member_nr)
      assert List.first(Users.search_users("public", member_nr)).id == user.id
    end

    test "search search_users/1 with a valid email" do
      user = user_fixture()
      assert List.first(Users.search_users("public", user.email)).id == user.id
    end

    test "search search_users/1 with a valid username" do
      user = user_fixture()
      assert List.first(Users.search_users("public", user.username)).id == user.id
    end

    test "search search_users/1 with invalid query returns an empty aray" do
      _user = user_fixture()
      assert Users.search_users("public", "XYZ123") == []
    end

    test "create_user/1 with valid data creates a user" do
      attrs = valid_attrs()
      assert {:ok, %User{} = user} = Users.create_user("public", attrs)
      assert user.username == attrs["username"]
      assert user.email == attrs["email"]
      assert user.mobile == attrs["mobile"]
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user("public", invalid_attrs())
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
      assert user.id == Users.get_user!("public", user.id).id
    end

    test "update_user/2 sets the set the unsubscribe_to_news_token" do
      user = user_fixture()
      attrs = update_attrs(user.id, %{"subscribe_to_news" => "true"})
      assert {:ok, %User{} = user} = Users.update_user(user, attrs)
      refute is_nil(user.unsubscribe_to_news_token)
    end

    test "update_user/2 sets the removes the unsubscribe_to_news_token" do
      user = user_fixture()
      attrs = update_attrs(user.id, %{"subscribe_to_news" => "false"})
      assert {:ok, %User{} = user} = Users.update_user(user, attrs)
      assert is_nil(user.unsubscribe_to_news_token)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!("public", user.id) end
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
      assert Users.get_order_by_token!("public", order.token).id == order.id
    end

    test "search order/1 with a valid order_nr" do
      user = user_fixture()
      order = order_fixture(user.id)
      {:ok, order} = Users.payment_accepted(order, "1", "0000 0000 0000 2134", "1234")

      assert List.first(Users.search_orders("public", Integer.to_string(order.order_nr))).id ==
               order.id
    end

    test "search order/1 with a valid username" do
      user = user_fixture()
      order = order_fixture(user.id, %{"state" => "payment_accepted"})
      assert List.first(Users.search_orders("public", user.username)).id == order.id
    end

    test "search order/1 with a valid email" do
      user = user_fixture()
      order = order_fixture(user.id, %{"state" => "payment_accepted"})
      assert List.first(Users.search_orders("public", user.email)).id == order.id
    end

    test "search order/1 invalid query returns nil" do
      user = user_fixture()
      _order = order_fixture(user.id)
      assert is_nil(List.first(Users.search_orders("public", "XYZ123")))
    end

    test "confirm_user/1 updates the confirmed_at field" do
      user = user_fixture()
      assert is_nil(user.confirmed_at)
      {:ok, %User{confirmed_at: confirmed_at}} = Users.confirm_user(user)
      assert confirmed_at == AOFF.Time.today()
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
        pick_up_fixture(%{
          "date_id" => date.id,
          "user_id" => user.id,
          "order_id" => order.id
        })

      _order_item =
        order_item_fixture(%{
          "order_id" => order.id,
          "product_id" => product.id,
          "date_id" => date.id,
          "user_id" => user.id,
          "pick_up_id" => pick_up.id
        })

      order = Users.get_order!("public", order.id)
      users = Users.extend_memberships(order)
      user = List.first(users)

      assert {:ok, %User{}} = user
      {:ok, user} = user

      assert user.expiration_date == Date.add(expiration_date, 365)
    end
  end

  describe "news mail" do
    alias AOFF.Users.User

    setup do
      {:ok, user: user_fixture()}
    end

    test "set_unsubscribe_to_news_token/1 sets the token", %{user: user} do
      assert {:ok, %AOFF.Users.User{unsubscribe_to_news_token: token}} =
               Users.set_unsubscribe_to_news_token(user)

      refute token == ""
    end

    test "get_user_by_unsubscribe_to_news_token/1 returns a user when the token is valid", %{
      user: user
    } do
      Users.set_unsubscribe_to_news_token(user)

      {:ok, %AOFF.Users.User{unsubscribe_to_news_token: token}} =
        Users.set_unsubscribe_to_news_token(user)

      assert user.id == Users.get_user_by_unsubscribe_to_news_token("public", token).id
    end

    test "get_user_by_unsubscribe_to_news_token/1 returns nil when the token is invalid" do
      assert is_nil(Users.get_user_by_unsubscribe_to_news_token("public", "invalid_token"))
    end

    test "unsubscribe_to_news/1 unsubscribe the user from emails", %{user: user} do
      {:ok, user} =
        Users.update_user(user, %{
          "subscribe_to_news" => "true",
          "unsubscribe_to_news_token" => Ecto.UUID.generate()
        })

      assert {:ok, %AOFF.Users.User{} = user} = Users.unsubscribe_to_news(user)
      assert is_nil(user.unsubscribe_to_news_token)
      refute user.subscribe_to_news
    end
  end
end
