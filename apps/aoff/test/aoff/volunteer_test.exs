defmodule AOFF.VolunteerTest do
  use AOFF.DataCase

  alias AOFF.Volunteers

  import AOFF.System.MessageFixture

  describe "messages" do
    alias AOFF.System.Message



    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Volunteers.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Volunteers.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do

      attrs = valid_message_attrs()
      assert {:ok, %Message{} = message} = Volunteers.create_message(attrs)
      assert message.text == attrs["text"]
      assert message.identifier == attrs["identifier"]
      assert message.locale == attrs["locale"]
      assert message.show == attrs["show"]
      assert message.title == attrs["title"]
    end

    test "create_message/1 with invalid data returns error changeset" do
      attrs = invalid_message_attrs()
      assert {:error, %Ecto.Changeset{}} = Volunteers.create_message(attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      attrs = update_message_attrs()
      assert {:ok, %Message{} = message} = Volunteers.update_message(message, attrs)
      assert message.text == attrs["text"]
      assert message.identifier == attrs["identifier"]
      assert message.locale == attrs["locale"]
      assert message.show == attrs["show"]
      assert message.title == attrs["title"]
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      attrs = invalid_message_attrs()
      assert {:error, %Ecto.Changeset{}} = Volunteers.update_message(message, attrs)
      assert message == Volunteers.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Volunteers.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Volunteers.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Volunteers.change_message(message)
    end
  end
end
