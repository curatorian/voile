defmodule Voile.Repo.Migrations.CreateResourceTemplate do
  use Ecto.Migration

  def change do
    create table(:resource_template) do
      add :label, :string
      add :owner, references(:users, on_delete: :nothing)
      add :resource_class, references(:resource_class, on_delete: :nothing)
      add :property, references(:metadata_properties, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:resource_template, [:owner])
    create index(:resource_template, [:resource_class])
    create index(:resource_template, [:property])
  end
end
