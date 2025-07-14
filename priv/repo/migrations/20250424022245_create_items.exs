defmodule Voile.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :item_code, :string
      add :inventory_code, :string
      add :barcode, :string
      add :location, :string
      add :status, :string
      add :condition, :string
      add :availability, :string
      add :unit_id, references(:nodes, on_delete: :nilify_all)
      add :collection_id, references(:collections, on_delete: :nilify_all, type: :uuid)

      timestamps(type: :utc_datetime)
    end

    create index(:items, [:collection_id])
  end
end
