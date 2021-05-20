defmodule ExpenseJar.Finance.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  @type period :: :day | :week | :month | :year

  @type t :: %__MODULE__{
          color: String.t(),
          cycle_amount: non_neg_integer(),
          cycle_period: period(),
          first_bill: Date.t(),
          icon: String.t(),
          name: String.t(),
          overview: String.t(),
          price: Money.Ecto.Composite.Type,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "subscriptions" do
    field :color, :string
    field :cycle_amount, :integer
    field :cycle_period, :string
    field :first_bill, :date, default: Date.utc_today()
    field :icon, :string
    field :name, :string
    field :overview, :string
    field :price, Money.Ecto.Composite.Type, default: Money.new(0)

    belongs_to :list, ExpenseJar.Finance.List
    belongs_to :user, ExpenseJar.Accounts.User, foreign_key: :created_by

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [
      :color,
      :cycle_amount,
      :cycle_period,
      :first_bill,
      :icon,
      :name,
      # :price,
      :overview
    ])
    |> cast_money(attrs, :price)
    |> validate_required([
      :color,
      :cycle_amount,
      :cycle_period,
      :first_bill,
      :icon,
      :name,
      # :price,
      :overview
    ])
    |> validate_money(:price)
    |> validate_inclusion(:cycle_period, periods())
  end

  def periods do
    ["day", "week", "month", "year"]
  end

  defp cast_money(changeset, params, _field) when params == %{}, do: changeset

  defp cast_money(changeset, params, field) do
    money = field
      |> to_string
      |> (&(Map.get(params, &1))).()
      |> Money.parse
      |> case do
        {:ok, m} -> m
        :error -> field
      end

    put_change(changeset, field, money)
  end


  defp validate_money(changeset, field) do
    validate_change(changeset, field, fn
      _, %Money{amount: amount} when amount > 0 -> []
      _, _ -> [{ field, "must be greater than 0" }]
    end)
  end
end
