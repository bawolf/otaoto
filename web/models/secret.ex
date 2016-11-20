defmodule Once.Secret do
  use Once.Web, :model

  alias Once.Repo

  @primary_key { :id, :binary_id, autogenerate: true }
  @derive { Phoenix.Param, key: :id }

  schema "secrets" do
    field :cipher_text, :string
    field :slug, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:cipher_text])
    |> put_change(:slug, new_slug)
    |> validate_required([:cipher_text, :slug])
  end

  defp new_slug do
    slug = MnemonicSlugs.generate_slug(String.to_integer(System.get_env("SLUG_LENGTH")))
    case Repo.get_by(Once.Secret, slug: slug) do
      { :ok, _secret } -> new_slug
      nil -> slug
    end
  end
end
