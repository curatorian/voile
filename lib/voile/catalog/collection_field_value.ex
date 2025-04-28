defmodule Voile.Catalog.CollectionFieldValue do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "collection_field_values" do
    field :value, :string
    field :locale, :string
    belongs_to :collection_field, Voile.Catalog.CollectionField, type: :binary_id
    belongs_to :item, Voile.Catalog.Item, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(collection_field_value, attrs) do
    collection_field_value
    |> cast(attrs, [:value, :locale])
    |> validate_required([:value, :locale])
  end
end
