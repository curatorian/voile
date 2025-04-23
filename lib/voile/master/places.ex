defmodule Voile.Master.Places do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mst_places" do
    field :place_name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(places, attrs) do
    places
    |> cast(attrs, [:place_name])
    |> validate_required([:place_name])
  end
end
