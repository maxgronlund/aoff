defmodule AOFFWeb.System.SetHost do
  import Plug.Conn
  alias AOFF.Admin
  def init(opts), do: opts

  def call(conn, _options) do
    prefix = Admin.get_prefix_by_host(conn.host)
    conn
    |> assign(:prefix, prefix)
  end
end
