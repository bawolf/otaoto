defmodule Once.BcryptTest do
  use Once.ConnCase

  defmodule FakeUser do
    use Ecto.Schema
    import Ecto.Changeset

    schema "fake_users" do
      field :key_hash
      field :key, :string, virtual: true
    end

    def create_changeset(changes) do
      %__MODULE__{}
      |> cast(changes, ~w(key))
      |> Once.Bcrypt.hash_key
    end
  end

  test "hash_key sets encrypted key on changeset when virtual field is present" do
    changeset = FakeUser.create_changeset(%{key: "foobar"})

    assert changeset.changes[:key_hash]
  end

  test "hash_key does not set encrypted key on changeset when virtual field is not present" do
    changeset = FakeUser.create_changeset(%{})

    refute changeset.changes[:key_hash]
  end
end