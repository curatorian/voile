defmodule Voile.Schema.Master.Creator do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mst_creator" do
    field :type, :string
    field :creator_name, :string
    field :creator_contact, :string
    field :affiliation, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(creator, attrs) do
    creator
    |> cast(attrs, [:creator_name, :creator_contact, :affiliation, :type])
    |> validate_required([:creator_name, :creator_contact, :affiliation, :type])
  end
end
