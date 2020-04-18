defmodule AOFFWeb.Volunteer.MessageView do
  use AOFFWeb, :view

  def show(show) do
    case show do
      true -> gettext("Visible")
      _ -> gettext("Hidden")
    end
  end
end
