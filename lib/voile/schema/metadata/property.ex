defmodule Voile.Schema.Metadata.Property do
  use Ecto.Schema
  import Ecto.Changeset

  alias Voile.Schema.Accounts.User
  alias Voile.Schema.Metadata.Vocabulary

  schema "metadata_properties" do
    field :label, :string
    field :local_name, :string
    field :information, :string
    belongs_to :owner, User
    belongs_to :vocabulary, Vocabulary

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, [:label, :local_name, :information, :vocabulary_id, :owner_id])
    |> validate_required([:label, :local_name, :vocabulary_id])
  end
end
