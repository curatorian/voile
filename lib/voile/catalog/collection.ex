defmodule Voile.Catalog.Collection do
  use Ecto.Schema
  import Ecto.Changeset

  alias Voile.Schema.Metadata.ResourceClass
  alias Voile.Schema.Metadata.ResourceTemplate
  alias Voile.Schema.Master.Creator
  alias Voile.Schema.System.Node
  alias Voile.Catalog.CollectionField

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "collections" do
    field :status, :string
    field :description, :string
    field :title, :string
    field :thumbnail, :string
    field :access_level, :string
    belongs_to :resource_class, ResourceClass, foreign_key: :type_id
    belongs_to :resource_template, ResourceTemplate, foreign_key: :template_id
    belongs_to :mst_creator, Creator, foreign_key: :creator_id
    belongs_to :node, Node, foreign_key: :unit_id
    has_many :collection_fields, CollectionField, on_replace: :nilify
    has_many :items, Voile.Catalog.Item, on_replace: :nilify

    timestamps(type: :utc_datetime)
  end

  @statuses ~w(draft pending published archived)
  @access_levels ~w(public private restricted)

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [
      :title,
      :description,
      :thumbnail,
      :status,
      :access_level,
      :type_id,
      :template_id,
      :creator_id,
      :unit_id
    ])
    |> cast_assoc(:collection_fields, with: &CollectionField.changeset/2, required: false)
    |> validate_required([:title, :description, :thumbnail, :status, :access_level, :creator_id],
      message: "This field is required"
    )
    |> unique_constraint(:title)
    |> validate_inclusion(:status, @statuses, message: "Status tidak valid")
    |> validate_inclusion(:access_level, @access_levels, message: "Access level tidak valid")
  end
end
