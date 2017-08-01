defmodule Once.SecretAPIController do
  use Once.Web, :controller

  alias Once.{ AES, Repo, Secret }

  def create(conn, %{ "secret" => raw_params }) do
    secret_params = AES.encrypt(raw_params["plain_text"])
    changeset = Secret.changeset(%Secret{}, secret_params)

    case Repo.insert(changeset) do
      { :ok, secret } ->
        link = secret_api_url(conn, :show, secret.slug, secret.key)

        conn
        |> put_status(:created)
        |> render("create.json",
                  secret: %{key: secret_params.key,
                            slug: secret.slug,
                            link: link})
      { :error, changeset } ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json", messages: changeset.errors)
    end
  end

  def show(conn, %{ "slug" => slug,"key" => key }) do
    case Repo.get_by(Secret, slug: slug) do
      nil ->
        conn
        |> render("errors.json", messages: "This link has expired or never existed")
      secret ->
        case AES.decrypt(secret.cipher_text, key) do
          { :ok, plain_text } ->
            Repo.delete(secret)

            conn
            |> render("show.json", plain_text: plain_text)
          { :error, _message } -> 
            conn
            |> render("errors.json", messages: "This link has expired or never existed")
        end
    end    
  end
end
