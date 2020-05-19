defmodule AOFF.SystemTest do
  use AOFF.DataCase

  alias AOFF.System

  import AOFF.Users.UserFixture
  import AOFF.System.SMSMessageFixture

  describe "sms_messages" do
    alias AOFF.System.SMSMessage

    setup do
      user = user_fixture()
      {:ok, user: user}
    end

    test "list_sms_messages/0 returns all sms_messages", %{user: user} do
      sms_message = sms_message_fixture(%{"user_id" => user.id})
      assert System.list_sms_messages() == [sms_message]
    end

    test "get_sms_message!/1 returns the sms_message with given id", %{user: user} do
      sms_message = sms_message_fixture(%{"user_id" => user.id})
      assert System.get_sms_message!(sms_message.id) == sms_message
    end

    test "create_sms_message/1 with valid data creates a sms_message", %{user: user} do
      attrs = valid_sms_message_attrs(%{"user_id" => user.id})
      assert {:ok, %SMSMessage{} = sms_message} = System.create_sms_message(attrs)
      assert sms_message.mobile == attrs["mobile"]
      assert sms_message.text == attrs["text"]
    end

    test "create_sms_message/1 with invalid data returns error changeset", %{user: user} do
      attrs = invalid_sms_message_attrs(%{"user_id" => user.id})
      assert {:error, %Ecto.Changeset{}} = System.create_sms_message(attrs)
    end

    test "delete_sms_message/1 deletes the sms_message", %{user: user} do
      sms_message = sms_message_fixture(%{"user_id" => user.id})
      assert {:ok, %SMSMessage{}} = System.delete_sms_message(sms_message)
      assert_raise Ecto.NoResultsError, fn -> System.get_sms_message!(sms_message.id) end
    end

    test "change_sms_message/1 returns a sms_message changeset", %{user: user} do
      sms_message = sms_message_fixture(%{"user_id" => user.id})
      assert %Ecto.Changeset{} = System.change_sms_message(sms_message)
    end
  end
end
