defmodule Voile.Metadata.ResourceClass do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resource_class" do
    field :label, :string
    field :local_name, :string
    field :information, :string
    field :owner, :id
    field :vocabulary, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(resource_class, attrs) do
    resource_class
    |> cast(attrs, [:label, :local_name, :information])
    |> validate_required([:label, :local_name, :information])
  end
end
