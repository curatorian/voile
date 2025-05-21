defmodule Voile.Catalog.CollectionField do
  use Ecto.Schema
  import Ecto.Changeset

  alias Voile.Catalog.Collection

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "collection_fields" do
    field :label, :string
    field :name, :string
    field :value, :string
    field :value_lang, :string
    field :type_value, :string
    field :sort_order, :integer
    field :col_field_values, :string, virtual: true
    belongs_to :collection, Collection, on_replace: :nilify, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(collection_field, attrs) do
    collection_field
    |> cast(attrs, [
      :name,
      :label,
      :value,
      :value_lang,
      :sort_order,
      :type_value,
      :collection_id
    ])
    |> validate_required([:name, :label, :value, :value_lang, :sort_order])
  end
end
