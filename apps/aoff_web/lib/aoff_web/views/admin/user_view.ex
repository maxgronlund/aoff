defmodule AOFFWeb.Admin.UserView do
  use AOFFWeb, :view

  def valid_membership(user) do
    if user.expiration_date == nil do
      "Inactive"
    else
      case Date.compare(user.expiration_date, Date.utc_today()) do
        :gt -> gettext("Valid member")
        :lt -> gettext("Inactive")
      end
    end
  end

  def valid?(user) do
    if user.expiration_date == nil do
      false
    else
      case Date.compare(user.expiration_date, Date.utc_today()) do
        :gt -> true
        :lt -> false
      end
    end
  end
end
