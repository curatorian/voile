defmodule Voile.Repo.Migrations.CreateResourceClass do
  use Ecto.Migration

  def change do
    create table(:resource_class) do
      add :label, :string
      add :local_name, :string
      add :information, :string
      add :owner, references(:users, on_delete: :nothing)
      add :vocabulary, references(:metadata_vocabularieslaries, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:resource_class, [:owner])
    create index(:resource_class, [:vocabulary])
  end
end
