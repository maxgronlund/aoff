defmodule AOFFWeb.System.SetHost do
  import Plug.Conn
  alias AOFF.Admin
  def init(opts), do: opts

  def call(conn, _options) do
    association = Admin.get_association_by_prefix(conn.host)

    conn
    |> assign(:prefix, association.prefix)
    |> assign(:association_name, association.name)
  end
end
