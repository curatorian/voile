defmodule Voile.Repo.Migrations.CreateCollectionFieldValues do
  use Ecto.Migration

  def change do
    create table(:collection_field_values, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :value, :string
      add :locale, :string

      add :collection_field_id,
          references(:collection_fields, on_delete: :nothing, type: :binary_id)

      add :item_id, references(:items, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:collection_field_values, [:collection_field_id])
    create index(:collection_field_values, [:item_id])
  end
end
