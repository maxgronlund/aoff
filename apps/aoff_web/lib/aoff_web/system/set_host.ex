defmodule AOFFWeb.System.SetHost do
  import Plug.Conn
  alias AOFF.Admin
  def init(opts), do: opts

  def call(conn, _options) do
    # prefix = Admin.get_prefix_by_host(conn.host)
    association = Admin.get_association_by_host(conn.host)
    conn
    |> assign(:prefix, association.prefix)
    |> assign(:association_name, association.name)
  end
end
