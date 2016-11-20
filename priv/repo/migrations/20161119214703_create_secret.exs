defmodule Once.Repo.Migrations.CreateSecret do
  use Ecto.Migration

  def change do
    create table(:secrets, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :cipher_text, :string
      add :slug, :string, unique: true

      timestamps()
    end

    create unique_index(:secrets, [:slug])
  end
end
