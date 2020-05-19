defmodule AOFFWeb.LayoutView do
  use AOFFWeb, :view

  def new_locale(locale, language_title, path \\ "") do
    # "<a href=\"#{Routes.page_path(conn, :index, locale: locale)}\">#{language_title}</a>" |> raw
    "<a href=\"#{path}?locale=#{locale}\">#{language_title}</a>" |> raw
  end

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

  alias AOFF.System

  def footer() do
    {:ok, message} =
      System.find_or_create_message(
        "footer",
        "Footer",
        Gettext.get_locale()
      )

    message
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
