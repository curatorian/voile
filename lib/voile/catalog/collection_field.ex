defmodule Voile.Catalog.CollectionField do
  use Ecto.Schema
  import Ecto.Changeset

  alias Voile.Catalog.Collection

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "collection_fields" do
    field :label, :string
    field :name, :string
    field :field_type, :string
    field :required, :boolean, default: false
    field :sort_order, :integer
    belongs_to :collection, Collection, on_replace: :nilify

    has_many :collection_field_values, Voile.Catalog.CollectionFieldValue,
      foreign_key: :collection_field_id,
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(collection_field, attrs) do
    collection_field
    |> cast(attrs, [:name, :label, :field_type, :required, :sort_order, :collection_id])
    |> validate_required([:name, :label, :field_type, :required, :sort_order, :collection_id])
  end
end
