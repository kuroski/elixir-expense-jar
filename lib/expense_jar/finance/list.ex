defmodule ExpenseJar.Finance.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :name, :string
    field :subscription_count, :integer, default: 0, virtual: true
    belongs_to :user, ExpenseJar.Accounts.User, foreign_key: :created_by
    has_many :subscriptions, ExpenseJar.Finance.Subscription

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
