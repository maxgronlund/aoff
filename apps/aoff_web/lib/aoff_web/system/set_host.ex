defmodule AOFFWeb.System.SetHost do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _options) do
    prefix =
      case conn.host do
        "1b6e2f270c4f.ngrok.io" ->
          "prefix_roff"

        _ ->
          "public"
      end

    conn
    |> assign(:prefix, prefix)
  end
end
