defmodule ExpenseJar.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :color, :string
      add :cycle_amount, :integer
      add :cycle_period, :string
      add :first_bill, :date
      add :icon, :string
      add :name, :string
      add :price, :money_with_currency
      add :overview, :string
      add :list_id, references(:lists, on_delete: :nothing)
      add :created_by, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:subscriptions, [:list_id])
    create index(:subscriptions, [:created_by])
  end
end
