defmodule Voile.Schema.Metadata.ResourceTemplate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resource_template" do
    field :label, :string
    field :owner, :id
    field :resource_class, :id
    field :property, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(resource_template, attrs) do
    resource_template
    |> cast(attrs, [:label])
    |> validate_required([:label])
  end
end
