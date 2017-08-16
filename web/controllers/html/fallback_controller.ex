defmodule Once.HTML.FallbackController do
  use Once.Web, :controller

  def call(conn, {:error, %changeset{}}) do
    conn
    |> put_flash(:error, "We could not create your secret.")
    |> render("new.html", changeset: changeset)
  end

  def call(conn, {:error, _message}) do
    conn
    |> redirect(to: secret_path(conn, :gone))
  end
end
