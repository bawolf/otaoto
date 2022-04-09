defmodule Once.Bcrypt do
  alias Comeonin.Bcrypt
  alias Ecto.Changeset

  def hash_key(changeset) do
    case Changeset.get_change(changeset, :key) do
      nil ->
        changeset

      key ->
        Changeset.put_change(changeset, :key_hash, Bcrypt.hashpwsalt(key))
    end
  end
end
