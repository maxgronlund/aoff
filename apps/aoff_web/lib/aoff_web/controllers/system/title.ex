defmodule AOFFWeb.System.Title do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn |> assign(:title, "AOFF")
  end
end
