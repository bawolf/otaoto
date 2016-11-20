defmodule Once.SecretController do
  use Once.Web, :controller

  alias Once.{ AES, Repo, Secret }

  def new(conn, _params) do
    changeset = Secret.changeset(%Secret{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{ "secret" => raw_params }) do
    secret_params = AES.encrypt(raw_params["plain_text"])
    changeset = Secret.changeset(%Secret{}, secret_params)
    case Repo.insert(changeset) do
      { :ok, secret } ->
        conn
        |> put_flash(:info, "Secret created successfully.")
        |> render "confirm.html", key: secret_params.key, slug: secret.slug, plain_text: raw_params["plain_text"] 
      { :error, changeset } ->
        conn
        |> put_flash(:error, "Could not create secret.")
        |> render("new.html", changeset: changeset)
    end
  end
end
