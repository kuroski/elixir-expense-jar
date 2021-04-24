defmodule ExpenseJar.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :created_by, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:lists, [:created_by])
  end
end
