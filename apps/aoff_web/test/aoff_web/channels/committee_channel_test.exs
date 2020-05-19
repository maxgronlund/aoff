defmodule AOFFWeb.CommitteeChannelTest do
  use AOFFWeb.ChannelCase

  import AOFF.Committees.CommitteeFixture

  setup do
    {:ok, _, socket} =
      socket(AOFFWeb.UserSocket, "user_id", %{some: :assign})
      |> subscribe_and_join(AOFFWeb.CommitteeChannel, "committee:lobby")

    committee = committee_fixture()
    {:ok, socket: socket, committee: committee}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push(socket, "ping", %{"hello" => "there"})
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to committee:lobby", %{socket: socket, committee: committee} do
    push(socket, "shout", %{
      "username" => "some username",
      "body" => "some body",
      "committee_id" => committee.id
    })

    assert_broadcast "shout", %{
      "username" => "some username",
      "body" => "some body"
    }
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push "broadcast", %{"some" => "data"}
  end
end
