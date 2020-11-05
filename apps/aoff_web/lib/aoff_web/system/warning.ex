defmodule AOFFWeb.System.Warning do
  import Plug.Conn

  alias AOFF.System

  def init(opts), do: opts

  def call(conn, _opts) do
    {:ok, warning} =
      System.find_or_create_message(
        "System warning",
        "System warning",
        Gettext.get_locale(),
        conn.assigns.prefix
      )

    conn |> assign(:warning, warning)
  end
end
