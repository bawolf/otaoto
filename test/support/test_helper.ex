defmodule Once.TestHelper do
  alias Once.{AES, Repo, Secret}

  def secret_from_plain_text(plain_text) do
    secret_params = AES.encrypt(plain_text)

    {:ok, secret} =
      %Secret{}
      |> Secret.changeset(secret_params)
      |> Repo.insert

    %{secret: secret, secret_params: secret_params}
  end
end
