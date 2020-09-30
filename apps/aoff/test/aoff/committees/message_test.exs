defmodule AOFF.Committees.MessageTest do
  use AOFF.DataCase

  alias AOFF.Committees
  alias AOFF.Committees.Message

  import AOFF.Committees.MessageFixture
  import AOFF.Committees.CommitteeFixture
  # import AOFF.Committees.MeetingFixture
  # import AOFF.Committees.MemberFixture
  # import AOFF.Users.UserFixture

  describe "messages" do
    # alias AOFF.Committees.Message

    setup do
      committee = committee_fixture()
      {:ok, committee: committee}
    end

    test "list_messages/0 returns all messages for a given committee", %{committee: committee} do
      message = message_fixture(%{"committee_id" => committee.id})
      assert List.first(Committees.list_messages(committee.id)).id == message.id
    end

    test "get_message!/1 returns the message with given id", %{committee: committee} do
      message = message_fixture(%{"committee_id" => committee.id})
      assert Committees.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message", %{committee: committee} do
      attrs = valid_message_attrs(%{"committee_id" => committee.id})
      assert {:ok, %Message{} = message} = Committees.create_message(attrs)
      assert message.title == attrs["title"]
      assert message.body == attrs["body"]
      assert message.from == attrs["from"]
    end

    test "create_message/1 with invalid data returns error changeset" do
      attrs = invalid_message_attrs()
      assert {:error, %Ecto.Changeset{}} = Committees.create_message(attrs)
    end

    # test "update_message/2 with valid data updates the message" do
    #   message = message_fixture()
    #   attrs = update_message_attrs()
    #   assert {:ok, %Message{} = message} = System.update_message(message, attrs)
    #   assert message.text == attrs["text"]
    #   assert message.identifier == attrs["identifier"]
    #   assert message.locale == attrs["locale"]
    #   assert message.show == attrs["show"]
    #   assert message.title == attrs["title"]
    # end

    # test "update_message/2 with invalid data returns error changeset" do
    #   message = message_fixture()
    #   attrs = invalid_message_attrs()
    #   assert {:error, %Ecto.Changeset{}} = System.update_message(message, attrs)
    #   assert message == System.get_message!(message.id)
    # end

    # test "delete_message/1 deletes the message" do
    #   message = message_fixture()
    #   assert {:ok, %Message{}} = System.delete_message(message)
    #   assert_raise Ecto.NoResultsError, fn -> System.get_message!(message.id) end
    # end

    test "change_message/1 returns a message changeset", %{committee: committee} do
      message = message_fixture(%{"committee_id" => committee.id})

      assert %Ecto.Changeset{} = Committees.change_message(message)
    end
  end
end
