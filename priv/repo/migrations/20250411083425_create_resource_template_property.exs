defmodule Voile.Repo.Migrations.CreateResourceTemplateProperty do
  use Ecto.Migration

  def change do
    create table(:resource_template_property) do
      add :alternate_label, :string
      add :alternate_information, :string
      add :position, :integer
      add :data_type, {:array, :string}
      add :is_required, :boolean, default: false, null: false
      add :permission, :string
      add :owner, references(:users, on_delete: :nothing)
      add :resource_template, references(:resource_template, on_delete: :nothing)
      add :property, references(:metadata_properties, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:resource_template_property, [:owner])
    create index(:resource_template_property, [:resource_template])
    create index(:resource_template_property, [:property])
  end
end
