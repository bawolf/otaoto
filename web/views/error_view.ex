defmodule Once.ErrorView do
  use Once.Web, :view

  def render("404.html", _assigns) do
    # "Page not found"
    render "error.html", %{}
  end

  def render("500.html", _assigns) do
    # "Internal server error"
    render "error.html", %{}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
