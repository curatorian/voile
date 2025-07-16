defmodule Voile.Schema.Metadata.ResourceTemplateProperty do
  use Ecto.Schema
  import Ecto.Changeset

  alias Voile.Schema.Metadata.ResourceTemplate
  alias Voile.Schema.Metadata.Property

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "resource_template_property" do
    field :position, :integer
    field :override_label, :string
    belongs_to :resource_template, ResourceTemplate, foreign_key: :template_id
    belongs_to :property, Property

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(resource_template_property, attrs) do
    resource_template_property
    |> cast(attrs, [
      :position,
      :override_label,
      :property_id,
      :template_id
    ])
    |> validate_required([
      :override_label,
      :position,
      :property_id
    ])
  end
end
