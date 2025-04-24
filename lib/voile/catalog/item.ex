defmodule Voile.Catalog.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "items" do
    field :status, :string
    field :location, :string
    field :item_code, :string
    field :inventory_code, :string
    field :barcode, :string
    field :condition, :string
    field :availability, :string
    field :collection, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:item_code, :inventory_code, :barcode, :location, :status, :condition, :availability])
    |> validate_required([:item_code, :inventory_code, :barcode, :location, :status, :condition, :availability])
  end
end
