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

  def user_menu(_conn, _page \\ :na) do
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

  def style(order_items_count) do
    if order_items_count > 0 do
      "display: block;"
    else
      "display: none;"
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
