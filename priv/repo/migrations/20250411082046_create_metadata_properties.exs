defmodule Voile.Repo.Migrations.CreateMetadataProperties do
  use Ecto.Migration

  def change do
    create table(:metadata_properties) do
      add :label, :string
      add :local_name, :string
      add :information, :text
      add :type_value, :string
      add :owner_id, references(:users, type: :uuid, on_delete: :nothing)
      add :vocabulary_id, references(:metadata_vocabularies, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:metadata_properties, [:owner_id])
    create index(:metadata_properties, [:vocabulary_id])
    create unique_index(:metadata_properties, [:label])
    create unique_index(:metadata_properties, [:local_name])
  end
end
