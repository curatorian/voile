defmodule Voile.Repo.Migrations.CreateMetadataVocabularies do
  use Ecto.Migration

  def change do
    create table(:metadata_vocabularies) do
      add :label, :string
      add :prefix, :string
      add :namespace_url, :string
      add :information, :string
      add :owner, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:metadata_vocabularies, [:owner])
  end
end
