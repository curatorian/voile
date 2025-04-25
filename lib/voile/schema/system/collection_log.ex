defmodule Voile.System.CollectionLog do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "collection_logs" do
    field :message, :string
    field :title, :string
    field :action, :string
    field :collection, :binary_id
    field :user, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(collection_log, attrs) do
    collection_log
    |> cast(attrs, [:title, :message, :action])
    |> validate_required([:title, :message, :action])
  end
end
