defmodule Voile.Schema.Accounts.UserRole do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_roles" do
    field :name, :string
    field :permissions, :map, default: %{}
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:name, :permissions, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
