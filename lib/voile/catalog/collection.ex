defmodule Voile.Catalog.Collection do
  use Ecto.Schema
  import Ecto.Changeset

  alias Voile.Schema.Metadata.ResourceClass
  alias Voile.Schema.Metadata.ResourceTemplate
  alias Voile.Schema.Master.Creator
  alias Voile.Schema.System.Node
  alias Voile.Catalog.CollectionField

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "collections" do
    field :status, :string
    field :description, :string
    field :title, :string
    field :thumbnail, :string
    field :access_level, :string
    belongs_to :resource_class, ResourceClass, foreign_key: :type
    belongs_to :resource_template, ResourceTemplate, foreign_key: :template
    belongs_to :mst_creator, Creator, foreign_key: :creator
    belongs_to :node, Node, foreign_key: :unit
    has_many :collection_fields, CollectionField, foreign_key: :collection_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [:title, :description, :thumbnail, :status, :access_level])
    |> cast_assoc(:collection_fields, with: &CollectionField.changeset/2, required: false)
    |> validate_required([:title, :description, :thumbnail, :status, :access_level])
  end
end
