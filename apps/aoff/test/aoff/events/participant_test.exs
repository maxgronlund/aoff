defmodule AOFF.Events.ParticipantTest do
  use AOFF.DataCase

  alias AOFF.Events.Participant
  alias AOFF.Events

  import AOFF.Users.UserFixture
  import AOFF.Events.ParticipantFixture
  import AOFF.Content.PageFixture
  import AOFF.Content.CategoryFixture

  describe "participants" do
    setup do
      user = user_fixture()
      category = category_fixture()
      page = page_fixture(category.id)
      {:ok, user: user, page: page}
    end

    test "list_participants/2 show all participating participants", %{user: user, page: page} do
      {:ok, participant} = participant_fixture(%{"user_id" => user.id, "page_id" => page.id})
      participants = Events.list_participants("public", :all, page.id)
      assert List.first(participants).id == participant.id
    end

    test "get_participant/1 returns one participant", %{user: user, page: page} do
      {:ok, participant} = participant_fixture(%{"user_id" => user.id, "page_id" => page.id})
      assert Events.get_participant("public", participant.id).id == participant.id
    end

    test "create_participant/1 with valid data creates a participant", %{user: user, page: page} do
      attrs = valid_participant_attrs(%{"user_id" => user.id, "page_id" => page.id})

      assert {:ok, %Participant{} = participant} = Events.create_participant("public", attrs)
      assert participant.state == attrs["state"]
    end

    test "delete_participant/1 deletes the participant", %{user: user, page: page} do
      {:ok, participant} = participant_fixture(%{"user_id" => user.id, "page_id" => page.id})
      assert assert {:ok, %Participant{}} = Events.delete_participant(participant)
    end

    test "delete_participation/1 update state to cancelled", %{user: user, page: page} do
      {:ok, participant} = participant_fixture(%{"user_id" => user.id, "page_id" => page.id})
      assert {:ok, %Participant{} = participant} = Events.delete_participant(participant)
      assert is_nil(Events.get_participant("public", participant.id))
    end
  end
end
