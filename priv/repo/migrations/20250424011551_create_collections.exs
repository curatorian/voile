defmodule Voile.Repo.Migrations.CreateCollections do
  use Ecto.Migration

  def change do
    create table(:collections, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :title, :string
      add :description, :string
      add :thumbnail, :string
      add :status, :string
      add :access_level, :string
      add :type, references(:resource_class, on_delete: :nilify_all)
      add :template, references(:resource_template, on_delete: :nilify_all)
      add :creator, references(:mst_creator, on_delete: :nilify_all)
      add :unit, references(:nodes, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end

    create index(:collections, [:type])
    create index(:collections, [:template])
    create index(:collections, [:creator])
    create index(:collections, [:unit])
  end
end
