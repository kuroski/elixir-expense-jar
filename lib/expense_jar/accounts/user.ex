defmodule ExpenseJar.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :avatar_url, :string
    field :email, :string
    field :name, :string
    field :profile_url, :string
    field :provider, :string
    field :uid, :string
    field :username, :string

    has_many :lists, ExpenseJar.Finance.List, foreign_key: :created_by
    has_many :subscriptions, ExpenseJar.Finance.Subscription, foreign_key: :created_by
    timestamps()
  end

  @required_attrs [:uid, :provider, :name, :username, :email, :avatar_url, :profile_url]

  @docs false
  def create_changeset(user, attrs) do
    user
    |> update_changeset(attrs)
  end

  @docs false
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:email)
    |> unique_constraint(:uid_provider)
  end
end
