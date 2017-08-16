defmodule Once.API.FallbackController do
  use Once.Web, :controller

  def call(conn, {:error, %changeset{}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("errors.json", messages: changeset.errors)
  end

  def call(conn, {:error, _message}) do
    conn
    |> put_status(:not_found)
    |> render("errors.json", messages: ["This link has expired or never existed"])
  end
end
