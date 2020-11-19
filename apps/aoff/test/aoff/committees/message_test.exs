defmodule AOFF.Committees.MessageTest do
  use AOFF.DataCase

  alias AOFF.Committees
  alias AOFF.Committees.Message

  import AOFF.Committees.MessageFixture
  import AOFF.Committees.CommitteeFixture

  describe "messages" do
    setup do
      committee = committee_fixture()
      {:ok, committee: committee}
    end

    test "list_messages/0 returns all messages for a given committee", %{committee: committee} do
      message = message_fixture(%{"committee_id" => committee.id})
      assert List.first(Committees.list_messages("public", committee.id)).id == message.id
    end

    test "get_message!/1 returns the message with given id", %{committee: committee} do
      message = message_fixture(%{"committee_id" => committee.id})
      assert Committees.get_message!("public", message.id).id == message.id
    end

    test "create_message/1 with valid data creates a message", %{committee: committee} do
      attrs = valid_message_attrs(%{"committee_id" => committee.id})
      assert {:ok, %Message{} = message} = Committees.create_message("public", attrs)
      assert message.title == attrs["title"]
      assert message.body == attrs["body"]
      assert message.from == attrs["from"]
    end

    test "create_message/1 with invalid data returns error changeset" do
      attrs = invalid_message_attrs()
      assert {:error, %Ecto.Changeset{}} = Committees.create_message("public", attrs)
    end

    test "change_message/1 returns a message changeset", %{committee: committee} do
      message = message_fixture(%{"committee_id" => committee.id})

      assert %Ecto.Changeset{} = Committees.change_message(message)
    end
  end
end
