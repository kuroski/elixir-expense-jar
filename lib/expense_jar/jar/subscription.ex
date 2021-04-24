defmodule ExpenseJar.Jar.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscriptions" do
    field :color, :string
    field :cycle_amount, :integer
    field :cycle_period, :string
    field :first_bill, :date
    field :icon, :string
    field :name, :string
    field :overview, :string
    field :price, :decimal
    field :list_id, :id
    field :created_by, :id

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:color, :cycle_amount, :cycle_period, :first_bill, :icon, :name, :price, :overview])
    |> validate_required([:color, :cycle_amount, :cycle_period, :first_bill, :icon, :name, :price, :overview])
  end
end
