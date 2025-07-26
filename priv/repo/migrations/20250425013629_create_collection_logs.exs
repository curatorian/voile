defmodule Voile.Repo.Migrations.CreateCollectionLogs do
  use Ecto.Migration

  def change do
    create table(:collection_logs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :message, :text
      add :action, :string
      add :collection_id, references(:collections, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:collection_logs, [:collection_id])
    create index(:collection_logs, [:user_id])
  end
end
