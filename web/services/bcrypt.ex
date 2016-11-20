defmodule Once.Bcrypt do
  alias Comeonin.Bcrypt
  alias Ecto.Changeset

  def hash_key(changeset) do
    key = Ecto.Changeset.get_change(changeset, :key)

    if key do
      hashed_key = Bcrypt.hashpwsalt(key)
      changeset
      |> Changeset.put_change(:key_hash, hashed_key)
    else
      changeset
    end
  end
end
