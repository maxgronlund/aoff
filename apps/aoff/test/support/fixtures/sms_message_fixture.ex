defmodule AOFF.System.SMSMessageFixture do

  alias AOFF.System


  @valid_sms_message_attrs %{"mobile" => "some sms", "text" => "some text"}
  @update_sms_message_attrs %{"mobile" => "some updated mobile", "text" => "some updated text"}
  @invalid_sms_message_attrs %{"mobile" => nil, "text" => nil}

  def valid_sms_message_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@valid_sms_message_attrs)
  end

  def update_sms_message_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@update_sms_message_attrs)
  end

  def invalid_sms_message_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@invalid_sms_message_attrs)
  end

  def sms_message_fixture(attrs \\ %{}) do
    {:ok, sms_message} =
      attrs
      |> Enum.into(@valid_sms_message_attrs)
      |> System.create_sms_message()

    sms_message
  end
end