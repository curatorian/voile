defmodule Voile.Repo.Migrations.CreateResourceTemplate do
  use Ecto.Migration

  def change do
    create table(:resource_template) do
      add :label, :string
      add :owner_id, references(:users, type: :uuid, on_delete: :nothing)
      add :resource_class_id, references(:resource_class, on_delete: :nothing)
      add :property_id, references(:metadata_properties, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:resource_template, [:owner_id])
    create index(:resource_template, [:resource_class_id])
    create index(:resource_template, [:property_id])
  end
end
