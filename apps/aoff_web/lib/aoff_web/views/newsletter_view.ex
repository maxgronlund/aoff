defmodule AOFFWeb.Volunteer.NewsletterView do
  use AOFFWeb, :view

  def date(date) do
    AOFF.Time.date_as_string(date)
  end
end
