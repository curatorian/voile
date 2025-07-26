defmodule Voile.Repo.Migrations.CreateResourceClass do
  use Ecto.Migration

  def change do
    create table(:resource_class) do
      add :label, :string
      add :local_name, :string
      add :information, :text
      add :owner_id, references(:users, type: :binary_id, on_delete: :nothing)
      add :vocabulary_id, references(:metadata_vocabularies, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:resource_class, [:owner_id])
    create index(:resource_class, [:vocabulary_id])
  end
end
