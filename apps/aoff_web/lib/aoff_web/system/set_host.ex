defmodule AOFFWeb.System.SetHost do
  import Plug.Conn
  alias AOFF.Admin
  def init(opts), do: opts

  def call(conn, _options) do
    prefix = Admin.get_prefix_by_host(conn.host)


    # IO.inspect association = Admin.get_host_by_prefix(conn.host)
    conn
    |> assign(:prefix, prefix)
    |> assign(:association_name, "AOFF")
  end
end
