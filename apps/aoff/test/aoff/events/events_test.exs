defmodule AOFF.EventsTest do
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

    # @valid_attrs %{name: "some name"}
    # @update_attrs %{name: "some updated name"}
    # @invalid_attrs %{name: nil}

    # def participant_fixture(attrs \\ %{}) do
    #   {:ok, participant} =
    #     attrs
    #     |> Enum.into(@valid_attrs)
    #     |> Event.create_participant()

    #   participant
    # end

    test "list_participants/2 show all participating participants", %{user: user, page: page} do
      {:ok, participant} =
        participant_fixture(%{
          "user_id" => user.id,
          "page_id" => page.id,
          "state" => "participating"
        })

      participants = Events.list_participants("public", :all, page.id)
      assert List.first(participants).id == participant.id
    end

    # test "list_participants/2 show cancled participants", %{user: user, page: page} do
    #   {:ok, participant} =
    #     participant_fixture(
    #       %{
    #         "user_id" => user.id,
    #         "page_id" => page.id,
    #         "state" => "participating"
    #       }
    #     )
    #   participants = Events.list_participants(:all, page.id)
    #   assert List.first(participants).id == participant.id
    # end

    test "get_participant!/1 returns the participant with given id", %{user: user, page: page} do
      {:ok, participant} =
        participant_fixture(%{
          "user_id" => user.id,
          "page_id" => page.id,
          "state" => "participating"
        })

      assert Events.get_participant("public", participant.id).id == participant.id
    end

    test "create_participant/1 with valid data creates a participant", %{user: user, page: page} do
      attrs =
        valid_participant_attrs(%{
          "user_id" => user.id,
          "page_id" => page.id,
          "state" => "participating"
        })

      assert {:ok, %Participant{} = participant} = Events.create_participant("public", attrs)
      assert participant.state == "participating"
    end

    test "create_participant/1 with invalid data returns error changeset" do
      attrs = invalid_participant_attrs()
      assert {:error, %Ecto.Changeset{}} = Events.create_participant(attrs)
    end

    test "update_participant/2 with valid data updates the participant", %{user: user, page: page} do
      {:ok, participant} =
        participant_fixture(%{
          "user_id" => user.id,
          "page_id" => page.id,
          "state" => "participating"
        })

      attrs = update_participant_attrs(%{"state" => "cancel"})
      assert {:ok, %Participant{} = participant} = Events.update_participant(participant, attrs)
      assert participant.state == "cancel"
    end

    test "update_participant/2 with invalid data returns a changeset", %{user: user, page: page} do
      {:ok, participant} =
        participant_fixture(%{
          "user_id" => user.id,
          "page_id" => page.id,
          "state" => "participating"
        })

      attrs = invalid_participant_attrs()
      assert {:error, %Ecto.Changeset{}} = Events.update_participant(participant, attrs)
    end

    # test "update_participant/2 with invalid data returns error changeset" do
    #   participant = participant_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Event.update_participant(participant, @invalid_attrs)
    #   assert participant == Event.get_participant!(participant.id)
    # end

    test "delete_participant/1 deletes the participant", %{user: user, page: page} do
      {:ok, participant} = participant_fixture(%{"user_id" => user.id, "page_id" => page.id})
      assert {:ok, %Participant{}} = Events.delete_participant(participant)
      assert is_nil(Events.get_participant("public", participant.id))
    end

    # test "change_participant/1 returns a participant changeset" do
    #   participant = participant_fixture()
    #   assert %Ecto.Changeset{} = Event.change_participant(participant)
    # end
  end
end
