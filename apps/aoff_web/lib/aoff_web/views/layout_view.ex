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
          0 -> "full backdrop-01"
          1 -> "full backdrop-02"
          2 -> "full backdrop-03"
          _ -> "full backdrop-04"
        end

      true ->
        ""
    end
  end
end
