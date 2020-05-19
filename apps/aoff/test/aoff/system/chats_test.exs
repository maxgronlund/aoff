defmodule AOFF.System.ChatsTest do
  use AOFF.DataCase
  import AOFF.Chat.MessageFixture
  import AOFF.Committees.CommitteeFixture

  alias AOFF.Chats

  describe "messages" do
    alias AOFF.Chats.Message

    # @valid_attrs %{body: "some body", username: "some username"}
    # @update_attrs %{body: "some updated body", username: "some updated username"}
    # @invalid_attrs %{body: nil, username: nil}

    # def message_fixture(attrs \\ %{}) do
    #   {:ok, message} =
    #     attrs
    #     |> Enum.into(@valid_attrs)
    #     |> Chats.create_message()

    #   message
    # end

    test "list_messages/0 returns all messages" do
      committee = committee_fixture()
      message = message_fixture(%{"committee_id" => committee.id})
      Chats.list_messages()
      assert List.first(Chats.list_messages()).id == message.id
    end

    test "get_message!/1 returns the message with given id" do
      committee = committee_fixture()
      message = message_fixture(%{"committee_id" => committee.id})
      assert Chats.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      committee = committee_fixture()
      attrs = valid_message_attrs(%{"committee_id" => committee.id})
      assert {:ok, %Message{} = message} = Chats.create_message(attrs)
      assert message.body == "some body"
      assert message.username == "some username"
    end

    test "create_message/1 with invalid data returns error changeset" do
      attrs = invalid_message_attrs()
      assert {:error, %Ecto.Changeset{}} = Chats.create_message(attrs)
    end

    test "update_message/2 with valid data updates the message" do
      committee = committee_fixture()
      message = message_fixture(%{"committee_id" => committee.id})
      attrs = update_message_attrs()
      assert {:ok, %Message{} = message} = Chats.update_message(message, attrs)
      assert message.body == attrs["body"]
      assert message.username == attrs["username"]
    end

    test "update_message/2 with invalid data returns error changeset" do
      committee = committee_fixture()
      message = message_fixture(%{"committee_id" => committee.id})
      attrs = invalid_message_attrs()
      assert {:error, %Ecto.Changeset{}} = Chats.update_message(message, attrs)
      assert message == Chats.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      committee = committee_fixture()
      message = message_fixture(%{"committee_id" => committee.id})
      assert {:ok, %Message{}} = Chats.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Chats.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      assert %Ecto.Changeset{} = Chats.change_message(%Message{})
    end
  end
end
