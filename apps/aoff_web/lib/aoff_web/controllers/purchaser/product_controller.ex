defmodule AOFFWeb.Purchaser.ProductController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFF.Shop.Product
  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index, :show, :edit, :new, :update, :create, :delete]

  def index(conn, _params) do
    products = Shop.list_products(conn.assigns.prefix)

    conn
    |> assign(:selected_menu_item, :volunteer)
    |> assign(:title, gettext("Products"))
    |> render("index.html", products: products)
  end

  def new(conn, _params) do
    changeset = Shop.change_product(%Product{})

    conn
    |> assign(:selected_menu_item, :volunteer)
    |> assign(:title, gettext("New Product"))
    |> render("new.html", changeset: changeset, amount: 0, product: false)
  end

  def create(conn, %{"product" => product_params}) do
    prefix = conn.assigns.prefix
    {price, _} = product_params["price"] |> Float.parse()
    price = Money.new(trunc(price * 100), :DKK)
    product_params = Map.put(product_params, "price", price)

    case Shop.create_product(prefix, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, gettext("Please attach image."))
        |> redirect(to: Routes.purchaser_product_path(conn, :edit, product))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          amount: product_params["price"],
          product: false
        )
    end
  end

  def show(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    product = Shop.get_product!(prefix, id)

    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    product = Shop.get_product!(prefix, id)
    changeset = Shop.change_product(product)

    conn
    |> assign(:selected_menu_item, :volunteer)
    |> assign(:title, gettext("Edit Product"))
    |> render("edit.html", product: product, changeset: changeset, amount: price(product.price))
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    {price, _} = product_params["price"] |> Float.parse()
    price = Money.new(trunc(price * 100), :DKK)
    product_params = Map.put(product_params, "price", price)
    prefix = conn.assigns.prefix
    product = Shop.get_product!(prefix, id)

    case Shop.update_product(product, product_params) do
      {:ok, product} ->
        if product.membership do
          conn
          |> put_flash(:info, gettext("Product updated successfully."))
          |> redirect(to: Routes.volunteer_membership_path(conn, :index))
        else
          conn
          |> put_flash(:info, gettext("Product updated successfully."))
          |> redirect(to: Routes.purchaser_product_path(conn, :index))
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          product: product,
          changeset: changeset,
          amount: price(product.price)
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    product = Shop.get_product!(prefix, id)
    {:ok, _product} = Shop.delete_product(product)

    conn
    |> put_flash(:info, gettext("Product deleted successfully."))
    |> redirect(to: Routes.purchaser_product_path(conn, :index))
  end

  defp price(product_price) do
    %Money{amount: amount} = product_price
    amount / 100
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.purchaser do
      conn
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
