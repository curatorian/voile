defmodule Voile.Repo.Migrations.CreateCollections do
  use Ecto.Migration

  def change do
    create table(:collections, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :title, :string
      add :description, :text
      add :thumbnail, :string
      add :status, :string
      add :access_level, :string
      add :type_id, references(:resource_class, on_delete: :nilify_all)
      add :template_id, references(:resource_template, on_delete: :nilify_all)
      add :creator_id, references(:mst_creator, on_delete: :nilify_all)
      add :unit_id, references(:nodes, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end

    create index(:collections, [:type_id])
    create index(:collections, [:template_id])
    create index(:collections, [:creator_id])
    create index(:collections, [:unit_id])
  end
end
