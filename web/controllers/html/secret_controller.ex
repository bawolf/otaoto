defmodule Once.HTML.SecretController do
  use Once.Web, :controller

  action_fallback Once.HTML.FallbackController

  alias Once.{AES, Repo, Secret}

  def new(conn, _params) do
    changeset = Secret.changeset(%Secret{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{ "secret" => raw_params }) do
    secret_params = AES.encrypt(raw_params["plain_text"])
    changeset = Secret.changeset(%Secret{}, secret_params)
    with {:ok, secret} <- Repo.insert(changeset) do
      conn
      |> render("confirm.html",
                key: secret_params.key,
                slug: secret.slug,
                plain_text: raw_params["plain_text"])
        
    end
  end

  def gate(conn, %{"slug" => slug,"key" => key}) do
    conn
    |> render("gate.html", slug: slug, key: key)
  end

  def show(conn, %{"slug" => slug, "key" => key}) do
    with :ok <- confirm_existence_of(slug, key),
         {:ok, secret} <- secret_from_slug(slug),
         {:ok, plain_text} <- AES.decrypt(secret.cipher_text, key)
          do
      Repo.delete(secret)
      conn
      |> render("show.html", plain_text: plain_text)
    end
  end

  def gone(conn, %{}) do
    conn
    |> render("gone.html")
  end

  defp secret_from_slug(slug) do
    case Repo.get_by(Secret, slug: slug) do
      nil -> {:error, :invalid_slug_or_key}
      %Once.Secret{} = secret -> {:ok, secret}
    end
  end

  defp confirm_existence_of(slug, key) do
    case !slug || !key do
      true -> {:error, :invalid_slug_or_key}
      false -> :ok
    end
  end
end
