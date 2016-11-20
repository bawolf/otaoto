defmodule Once.Repo.Migrations.CipherTextIsText do
  use Ecto.Migration

  def change do
    alter table(:secrets) do
      modify :cipher_text, :text
    end
  end
end
