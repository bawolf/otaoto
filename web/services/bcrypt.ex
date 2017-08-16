defmodule Once.Bcrypt do
  alias Comeonin.Bcrypt
  alias Ecto.Changeset

  def hash_key(changeset) do
    case Ecto.Changeset.get_change(changeset, :key) do
      nil ->
        changeset
      key ->
        changeset
        |> Changeset.put_change(:key_hash, Bcrypt.hashpwsalt(key))
    end
  end
end
