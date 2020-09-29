defmodule AOFF.CommitteesTest do
  use AOFF.DataCase

  alias AOFF.Committees

  describe "messages" do
    alias AOFF.Committees.Message

    @valid_attrs %{body: "some body", from: "some from", posted_at: "2010-04-17T14:00:00.000000Z", title: "some title"}
    @update_attrs %{body: "some updated body", from: "some updated from", posted_at: "2011-05-18T15:01:01.000000Z", title: "some updated title"}
    @invalid_attrs %{body: nil, from: nil, posted_at: nil, title: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Committees.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Committees.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Committees.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = Committees.create_message(@valid_attrs)
      assert message.body == "some body"
      assert message.from == "some from"
      assert message.posted_at == DateTime.from_naive!(~N[2010-04-17T14:00:00.000000Z], "Etc/UTC")
      assert message.title == "some title"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Committees.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, %Message{} = message} = Committees.update_message(message, @update_attrs)
      assert message.body == "some updated body"
      assert message.from == "some updated from"
      assert message.posted_at == DateTime.from_naive!(~N[2011-05-18T15:01:01.000000Z], "Etc/UTC")
      assert message.title == "some updated title"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Committees.update_message(message, @invalid_attrs)
      assert message == Committees.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Committees.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Committees.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Committees.change_message(message)
    end
  end
end
