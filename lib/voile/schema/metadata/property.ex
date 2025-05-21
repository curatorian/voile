defmodule Voile.Schema.Metadata.Property do
  use Ecto.Schema
  import Ecto.Changeset

  alias Voile.Schema.Accounts.User
  alias Voile.Schema.Metadata.Vocabulary

  schema "metadata_properties" do
    field :label, :string
    field :local_name, :string
    field :information, :string

    field :type_value, Ecto.Enum,
      values: [
        :text,
        :number,
        :email,
        :date,
        :datetime_local,
        :month,
        :tel,
        :time,
        :url,
        :week,
        :color,
        :range,
        :textarea
      ]

    belongs_to :owner, User
    belongs_to :vocabulary, Vocabulary

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, [:label, :local_name, :information, :type_value, :vocabulary_id, :owner_id])
    |> validate_required([:label, :local_name, :type_value, :vocabulary_id, :owner_id])
  end
end
