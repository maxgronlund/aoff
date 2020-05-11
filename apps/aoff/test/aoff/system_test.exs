defmodule AOFF.SystemTest do
  use AOFF.DataCase
  import AOFF.Users.UserFixture

  alias AOFF.System

  describe "sms_messages" do
    alias AOFF.System.SMSMessage

    setup do
      user = user_fixture()
      {:ok, user: user}
    end

    @valid_attrs %{sms: "some sms", text: "some text"}
    @update_attrs %{sms: "some updated sms", text: "some updated text"}
    @invalid_attrs %{sms: nil, text: nil}

    def sms_message_fixture(attrs \\ %{}) do
      {:ok, sms_message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> System.create_sms_message()

      sms_message
    end

    test "list_sms_messages/0 returns all sms_messages" do
      sms_message = sms_message_fixture()
      assert System.list_sms_messages() == [sms_message]
    end

    test "get_sms_message!/1 returns the sms_message with given id" do
      sms_message = sms_message_fixture()
      assert System.get_sms_message!(sms_message.id) == sms_message
    end

    test "create_sms_message/1 with valid data creates a sms_message" do
      assert {:ok, %SMSMessage{} = sms_message} = System.create_sms_message(@valid_attrs)
      assert sms_message.sms == "some sms"
      assert sms_message.text == "some text"
    end

    test "create_sms_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = System.create_sms_message(@invalid_attrs)
    end

    test "update_sms_message/2 with valid data updates the sms_message" do
      sms_message = sms_message_fixture()
      assert {:ok, %SMSMessage{} = sms_message} = System.update_sms_message(sms_message, @update_attrs)
      assert sms_message.sms == "some updated sms"
      assert sms_message.text == "some updated text"
    end

    test "update_sms_message/2 with invalid data returns error changeset" do
      sms_message = sms_message_fixture()
      assert {:error, %Ecto.Changeset{}} = System.update_sms_message(sms_message, @invalid_attrs)
      assert sms_message == System.get_sms_message!(sms_message.id)
    end

    test "delete_sms_message/1 deletes the sms_message" do
      sms_message = sms_message_fixture()
      assert {:ok, %SMSMessage{}} = System.delete_sms_message(sms_message)
      assert_raise Ecto.NoResultsError, fn -> System.get_sms_message!(sms_message.id) end
    end

    test "change_sms_message/1 returns a sms_message changeset" do
      sms_message = sms_message_fixture()
      assert %Ecto.Changeset{} = System.change_sms_message(sms_message)
    end
  end
end
