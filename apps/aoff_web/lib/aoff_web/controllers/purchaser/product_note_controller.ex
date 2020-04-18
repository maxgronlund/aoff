defmodule AOFFWeb.Purchaser.ProductNoteController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFF.System

  def edit(conn, %{
        "date_id" => date_id,
        "id" => id
      }) do
    product = Shop.get_product!(id)
    changeset = Shop.change_product(product)
    date = Shop.get_date!(date_id)

    {:ok, this_weeks_content_message} =
      System.find_or_create_message(
        "/purchaser/dates/:id/products_notes/:id - week",
        "This weeks content",
        Gettext.get_locale()
      )

    {:ok, notes_for_the_hosts} =
      System.find_or_create_message(
        "/purchaser/dates/:id/products_notes/:id - hosts",
        "Notes fot the hosts",
        Gettext.get_locale()
      )

    render(conn, "edit.html",
      date: date,
      product: product,
      changeset: changeset,
      this_weeks_content_message: this_weeks_content_message,
      notes_for_the_hosts: notes_for_the_hosts
    )
  end

  def update(conn, %{"id" => id, "date_id" => date_id, "product" => product_params}) do
    product = Shop.get_product!(id)
    Shop.update_product(product, product_params)

    conn
    |> put_flash(:info, gettext("Product is updated"))
    |> redirect(to: Routes.purchaser_date_path(conn, :show, date_id))
  end
end