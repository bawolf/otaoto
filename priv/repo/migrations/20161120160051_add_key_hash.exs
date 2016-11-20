defmodule Once.Repo.Migrations.AddKeyHash do
  use Ecto.Migration

  def change do
    alter table(:secrets) do
      add :key_hash, :string, null: false
    end
  end
end
