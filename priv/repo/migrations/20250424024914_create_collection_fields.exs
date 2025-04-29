defmodule Voile.Repo.Migrations.CreateCollectionFields do
  use Ecto.Migration

  def change do
    create table(:collection_fields, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :name, :string
      add :label, :string
      add :field_type, :string
      add :required, :boolean, default: false, null: false
      add :sort_order, :integer
      add :collection_id, references(:collections, on_delete: :nilify_all, type: :uuid)

      timestamps(type: :utc_datetime)
    end

    create index(:collection_fields, [:collection_id])
  end
end
