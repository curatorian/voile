defmodule Voile.Repo.Migrations.CreateCollectionLogs do
  use Ecto.Migration

  def change do
    create table(:collection_logs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :message, :string
      add :action, :string
      add :collection, references(:collections, on_delete: :nothing, type: :binary_id)
      add :user, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:collection_logs, [:collection])
    create index(:collection_logs, [:user])
  end
end
