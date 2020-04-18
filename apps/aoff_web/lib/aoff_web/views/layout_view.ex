defmodule AOFFWeb.LayoutView do
  use AOFFWeb, :view

  def menu_item(conn, page \\ :na) do
    cond do
      conn.assigns[:page] == page ->
        "menu-item active"

      true ->
        "menu-item"
    end
  end

  def user_menu(conn, page \\ :na) do
    "selected"
  end

  def user_tab(conn, page \\ :na) do
    cond do
      conn.assigns[:page] == page ->
        "is-active"

      true ->
        ""
    end
  end

  def backdrop(conn) do
    cond do
      conn.assigns[:backdrop] == :show ->
        case Enum.random(0..3) do
          0 -> "fixed-backdrop backdrop-01"
          1 -> "fixed-backdrop backdrop-02"
          2 -> "fixed-backdrop backdrop-03"
          _ -> "fixed-backdrop backdrop-04"
        end

      true ->
        ""
    end
  end
end
