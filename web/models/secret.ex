defmodule Once.Secret do
  use Once.Web, :model

  alias Once.Repo
  import Once.Bcrypt, only: [hash_key: 1]

  @primary_key { :id, :binary_id, autogenerate: true }
  @derive { Phoenix.Param, key: :id }

  schema "secrets" do
    field :cipher_text, :string
    field :slug, :string, unique: true
    field :key_hash, :string
    field :key, :string, virtual: true

    timestamps()
  end

  @required_fields ~w(cipher_text key)
  @optional_fields ~w()

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> hash_key
    |> put_change(:slug, new_slug)
    |> validate_required([:cipher_text, :slug, :key_hash])
  end

  defp new_slug do
    slug = MnemonicSlugs.generate_slug(Application.get_env(:once, :slug_length))
    case Repo.get_by(Once.Secret, slug: slug) do
      { :ok, _secret } -> new_slug
      nil -> slug
    end
  end
end
