defmodule AOFFWeb.Users.PurchaserView do
  use AOFFWeb, :view

  alias AOFF.System

  def purchaser_message(prefix) do
    {:ok, message} =
      System.find_or_create_message(
        "/shop/ - purchaser",
        "Purchasers landing page",
        Gettext.get_locale(),
        prefix
      )

    message
  end
end
