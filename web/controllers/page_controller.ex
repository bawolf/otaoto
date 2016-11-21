defmodule Once.PageController do
  use Once.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
