defmodule Voile.Catalog.ItemFieldValue do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "item_field_values" do
    field :value, :string
    field :locale, :string
    field :item_id, :id
    field :collection_field_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item_field_value, attrs) do
    item_field_value
    |> cast(attrs, [:value, :locale])
    |> validate_required([:value, :locale])
  end
end
