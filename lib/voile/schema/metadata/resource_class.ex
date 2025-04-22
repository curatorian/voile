defmodule Voile.Schema.Metadata.ResourceClass do
  use Ecto.Schema
  import Ecto.Changeset

  alias Voile.Schema.Accounts.User
  alias Voile.Schema.Metadata.Vocabulary

  schema "resource_class" do
    field :label, :string
    field :local_name, :string
    field :information, :string
    belongs_to :owner, User
    belongs_to :vocabulary, Vocabulary

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(resource_class, attrs) do
    resource_class
    |> cast(attrs, [:label, :local_name, :information])
    |> validate_required([:label, :local_name, :information])
  end
end
