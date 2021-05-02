defmodule ExpenseJar.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :email, :citext, null: false
      add :uid, :string, null: false
      add :provider, :string, null: false
      add :name, :string
      add :username, :string, null: false
      add :avatar_url, :string
      add :profile_url, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:uid, :provider])
  end
end
