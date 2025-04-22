defmodule Voile.Schema.Metadata.ResourceTemplate do
  use Ecto.Schema
  import Ecto.Changeset

  alias Voile.Schema.Accounts.User
  alias Voile.Schema.Metadata.ResourceClass
  alias Voile.Schema.Metadata.Property

  schema "resource_template" do
    field :label, :string
    belongs_to :owner, User
    belongs_to :resource_class, ResourceClass
    belongs_to :property, Property

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(resource_template, attrs) do
    resource_template
    |> cast(attrs, [:label])
    |> validate_required([:label])
  end
end
