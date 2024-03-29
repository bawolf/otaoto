defmodule Once.ErrorViewTest do
  use Once.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(Once.ErrorView, "404.html", []) =~
             "This page doesn't exist"
  end

  test "render 500.html" do
    assert render_to_string(Once.ErrorView, "500.html", []) =~
             "This page doesn't exist"
  end

  test "render any other" do
    assert render_to_string(Once.ErrorView, "505.html", []) =~
             "This page doesn't exist"
  end
end
