defmodule AOFFWeb.Users.PurchaserView do
  use AOFFWeb, :view

  alias AOFF.System

  def purchaser_message() do
    {:ok, message} =
      System.find_or_create_message(
        "/shop/ - purchaser",
        "Purchasers landing page",
        Gettext.get_locale()
      )

    message
  end
end
