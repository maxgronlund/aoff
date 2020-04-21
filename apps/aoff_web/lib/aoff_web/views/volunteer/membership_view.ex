defmodule AOFFWeb.Volunteer.MembershipView do
  use AOFFWeb, :view

  def for_sale(for_sale) do
    if for_sale, do: gettext("Show in shop √"), else: gettext("Hidden")
  end
end