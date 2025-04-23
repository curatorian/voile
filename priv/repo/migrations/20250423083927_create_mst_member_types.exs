defmodule Voile.Repo.Migrations.CreateMstMemberTypes do
  use Ecto.Migration

  def change do
    create table(:mst_member_types) do
      add :name, :string
      add :loan_limit, :integer
      add :loan_period, :integer
      add :enable_reserve, :boolean, default: false, null: false
      add :membership_period, :integer
      add :reloan_limit, :integer
      add :loan_fine, :integer
      add :loan_grace_period, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
