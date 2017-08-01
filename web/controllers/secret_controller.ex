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
        |> render("confirm.html",
                  key: secret_params.key,
                  slug: secret.slug,
                  plain_text: raw_params["plain_text"])
      { :error, changeset } ->
        conn
        |> put_flash(:error, "We could not create your secret.")
        |> render("new.html", changeset: changeset)
    end
  end

  def gate(conn, %{ "slug" => slug,"key" => key }) do
    conn
    |> render("gate.html", slug: slug, key: key)
  end

  def show(conn, %{ "slug" => slug,"key" => key }) do
    if !slug || !key do
      conn
      |> redirect(to: secret_path(conn, :gone)) 
    end
    case Repo.get_by(Secret, slug: slug) do
      nil ->
        conn
        |> redirect(to: secret_path(conn, :gone))
      secret ->
        case AES.decrypt(secret.cipher_text, key) do
          { :ok, plain_text } ->
            Repo.delete(secret)
            conn
            |> render("show.html", plain_text: plain_text)
          { :error, _message } -> 
            conn
            |> redirect(to: secret_path(conn, :gone))
        end
    end    
  end

  def gone(conn, %{}) do
    conn
    |> render("gone.html")
  end
end
