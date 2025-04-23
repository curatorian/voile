defmodule Voile.Master.MemberType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mst_member_types" do
    field :name, :string
    field :loan_limit, :integer
    field :loan_period, :integer
    field :enable_reserve, :boolean, default: false
    field :membership_period, :integer
    field :reloan_limit, :integer
    field :loan_fine, :integer
    field :loan_grace_period, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(member_type, attrs) do
    member_type
    |> cast(attrs, [:name, :loan_limit, :loan_period, :enable_reserve, :membership_period, :reloan_limit, :loan_fine, :loan_grace_period])
    |> validate_required([:name, :loan_limit, :loan_period, :enable_reserve, :membership_period, :reloan_limit, :loan_fine, :loan_grace_period])
  end
end
