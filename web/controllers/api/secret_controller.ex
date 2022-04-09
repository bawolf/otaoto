defmodule Once.API.SecretController do
  use Once.Web, :controller

  action_fallback(Once.API.FallbackController)

  alias Once.{AES, Repo, Secret}

  def create(conn, %{"secret" => raw_params}) do
    secret_params = AES.encrypt(raw_params["plain_text"])
    changeset = Secret.changeset(%Secret{}, secret_params)

    with {:ok, secret} <- Repo.insert(changeset) do
      link = api_secret_url(conn, :show, secret.slug, secret.key)

      conn
      |> put_status(:created)
      |> render("create.json",
        secret: %{key: secret_params.key, slug: secret.slug, link: link}
      )
    end
  end

  def show(conn, %{"slug" => slug, "key" => key}) do
    with :ok <- confirm_existence_of(slug, key),
         {:ok, secret} <- secret_from_slug(slug),
         {:ok, plain_text} <- AES.decrypt(secret.cipher_text, key) do
      Repo.delete(secret)

      conn
      |> render("show.json", plain_text: plain_text)
    end
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
