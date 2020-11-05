defmodule AOFF.System.MessageTest do
  use AOFF.DataCase

  alias AOFF.System

  import AOFF.System.MessageFixture

  describe "messages" do
    alias AOFF.System.Message

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert List.first(System.list_messages("public")).id == message.id
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert System.get_message!(message.id, "public") == message
    end

    test "create_message/1 with valid data creates a message" do
      attrs = valid_message_attrs()
      assert {:ok, %Message{} = message} = System.create_message(attrs, "public")
      assert message.text == attrs["text"]
      assert message.identifier == attrs["identifier"]
      assert message.locale == attrs["locale"]
      assert message.show == attrs["show"]
      assert message.title == attrs["title"]
    end

    test "create_message/1 with invalid data returns error changeset" do
      attrs = invalid_message_attrs()
      assert {:error, %Ecto.Changeset{}} = System.create_message(attrs, "public")
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      attrs = update_message_attrs()
      assert {:ok, %Message{} = message} = System.update_message(message, attrs)
      assert message.text == attrs["text"]
      assert message.identifier == attrs["identifier"]
      assert message.locale == attrs["locale"]
      assert message.show == attrs["show"]
      assert message.title == attrs["title"]
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      attrs = invalid_message_attrs()
      assert {:error, %Ecto.Changeset{}} = System.update_message(message, attrs)
      assert message == System.get_message!(message.id, "public")
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = System.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> System.get_message!(message.id, "public") end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = System.change_message(message)
    end
  end
end
