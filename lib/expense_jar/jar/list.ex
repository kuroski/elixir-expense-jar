defmodule ExpenseJar.Jar.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    belongs_to :user, ExpenseJar.Accounts.User, foreign_key: :created_by
    has_many :subscriptions, ExpenseJar.Jar.Subscription

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [])
    |> validate_required([])
  end
end
