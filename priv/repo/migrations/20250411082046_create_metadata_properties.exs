defmodule Voile.Repo.Migrations.CreateMetadataProperties do
  use Ecto.Migration

  def change do
    create table(:metadata_properties) do
      add :label, :string
      add :local_name, :string
      add :information, :string
      add :owner, references(:users, on_delete: :nothing)
      add :vocabulary, references(:metadata_vocabularies, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:metadata_properties, [:owner])
    create index(:metadata_properties, [:vocabulary])
  end
end
