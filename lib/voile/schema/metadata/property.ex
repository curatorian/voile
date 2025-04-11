defmodule Voile.Schema.Metadata.Property do
  use Ecto.Schema
  import Ecto.Changeset

  schema "metadata_properties" do
    field :label, :string
    field :local_name, :string
    field :information, :string
    field :owner, :id
    field :vocabulary, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, [:label, :local_name, :information])
    |> validate_required([:label, :local_name, :information])
  end
end
