# defmodule AOFFWeb.ErrorView do
#   use AOFFWeb, :view

#   # If you want to customize a particular status code
#   # for a certain format, you may uncomment below.

#   def render("500.html", _assigns) do
#     render("500_page.html", %{})
#   end

#   def render("401.html", _assigns) do
#     render("401_page.html", %{})
#   end

#   def render("404.html", _assigns) do
#     render("404_page.html", %{})
#   end

#   # By default, Phoenix returns the status message from
#   # the template name. For example, "404.html" becomes
#   # "Not Found".
#   def template_not_found(template, _assigns) do
#     Phoenix.Controller.status_message_from_template(template)
#   end
# end

defmodule AOFFWeb.ErrorView do
  use AOFFWeb, :view

  def render("401.html", _assigns) do
    render("401_page.html", %{})
  end

  def render("404.html", _assigns) do
    render("404_page.html", %{})
  end

  def render("500.html", _assigns) do
    render("500_page.html", %{})
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end