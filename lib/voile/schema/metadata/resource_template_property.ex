defmodule Voile.Schema.Metadata.ResourceTemplateProperty do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resource_template_property" do
    field :position, :integer
    field :data_type, {:array, :string}
    field :alternate_label, :string
    field :alternate_information, :string
    field :is_required, :boolean, default: false
    field :permission, :string
    field :owner, :id
    field :resource_template, :id
    field :property, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(resource_template_property, attrs) do
    resource_template_property
    |> cast(attrs, [
      :alternate_label,
      :alternate_information,
      :position,
      :data_type,
      :is_required,
      :permission
    ])
    |> validate_required([
      :alternate_label,
      :alternate_information,
      :position,
      :data_type,
      :is_required,
      :permission
    ])
  end
end
