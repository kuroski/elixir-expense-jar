defmodule ExpenseJar.Finance do
  @moduledoc """
  The Finance context.
  """

  import Ecto.Query, warn: false
  alias ExpenseJar.Repo
  alias ExpenseJar.Accounts.User

  alias ExpenseJar.Finance.List

  @doc """
  Returns the list of user lists.

  ## Examples

      iex> list_lists(%User{})
      [%List{}, ...]

  """
  def list_user_lists(%User{} = user) do
    subscription_count = get_subscriptions_count()

    List
    |> where_user_query(user)
    |> Repo.all()
    |> Enum.map(&%{&1 | subscription_count: subscription_count[&1.id] || 0})
  end

  @doc """
  Gets a single list.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list!(123)
      %List{}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list!(id), do: Repo.get!(List, id)

  @doc """
  Gets a single list.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_user_list!(%User{}, 123)
      %List{}

      iex> get_user_list!(%User{}, 456)
      ** (Ecto.NoResultsError)

  """
  def get_user_list!(%User{} = user, id),
    do:
      List
      |> where_user_query(user)
      # Example of anonymous function in pipe
      |> (&from(l in &1, left_join: s in assoc(l, :subscriptions), preload: [subscriptions: s])).()
      |> Repo.get!(id)

  @doc """
  Gets a single list.

  Returns nil if the List does not exist.

  ## Examples

      iex> get_list(123)
      %List{}

      iex> get_list(-1)
      nil
  """
  def get_list(id), do: Repo.get(List, id)

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%ExpenseJar.Accounts.User{}, %{field: value})
      {:ok, %List{}}

      iex> create_list(%ExpenseJar.Accounts.User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(%ExpenseJar.Accounts.User{} = user, attrs \\ %{}) do
    %List{}
    |> List.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list(%List{} = list, attrs) do
    list
    |> List.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a list.

  ## Examples

      iex> delete_list(list)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(%List{} = list) do
    Repo.delete(list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{data: %List{}}

  """
  def change_list(%List{} = list, attrs \\ %{}) do
    List.changeset(list, attrs)
  end

  alias ExpenseJar.Finance.Subscription

  @doc """
  Returns the list of subscriptions.

  ## Examples

      iex> list_subscriptions()
      [%Subscription{}, ...]

  """
  def list_subscriptions do
    Repo.all(Subscription)
  end

  @doc """
  Gets a single subscription.

  Raises `Ecto.NoResultsError` if the Subscription does not exist.

  ## Examples

      iex> get_subscription!(123)
      %Subscription{}

      iex> get_subscription!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscription!(id), do: Repo.get!(Subscription, id)

  @doc """
  Creates a subscription.

  ## Examples

      iex> create_subscription(%{user: %ExpenseJar.Accounts.User{}, list: %ExpenseJar.Finance.List{}}, %{field: value})
      {:ok, %Subscription{}}

      iex> create_subscription(%{user: %ExpenseJar.Accounts.User{}, list: %ExpenseJar.Finance.List{}}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscription(
        %{user: %ExpenseJar.Accounts.User{}, list: %ExpenseJar.Finance.List{}} = params,
        attrs \\ %{}
      ) do
    %Subscription{}
    |> Subscription.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, params.user)
    |> Ecto.Changeset.put_assoc(:list, params.list)
    |> Repo.insert()
  end

  @doc """
  Updates a subscription.

  ## Examples

      iex> update_subscription(subscription, %{field: new_value})
      {:ok, %Subscription{}}

      iex> update_subscription(subscription, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subscription(%Subscription{} = subscription, attrs) do
    subscription
    |> Subscription.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a subscription.

  ## Examples

      iex> delete_subscription(subscription)
      {:ok, %Subscription{}}

      iex> delete_subscription(subscription)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscription(%Subscription{} = subscription) do
    Repo.delete(subscription)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscription changes.

  ## Examples

      iex> change_subscription(subscription)
      %Ecto.Changeset{data: %Subscription{}}

  """
  def change_subscription(%Subscription{} = subscription, attrs \\ %{}) do
    Subscription.changeset(subscription, attrs)
  end

  def next_billing_for(subscription, now \\ Timex.today())

  def next_billing_for(
        %Subscription{
          cycle_period: "day",
          first_bill: first_bill,
          cycle_amount: cycle_amount
        },
        now
      ) do
    difference_in_days = Timex.diff(now, first_bill, :days)

    first_bill
    |> Timex.add(Timex.Duration.from_days(difference_in_days + cycle_amount))
  end

  def next_billing_for(
        %Subscription{
          cycle_period: "week",
          first_bill: first_bill,
          cycle_amount: cycle_amount
        },
        now
      ) do
    difference_in_weeks = Timex.diff(now, first_bill, :weeks)
    mod = rem(difference_in_weeks, cycle_amount)

    next_bill = Timex.set(first_bill, year: now.year, month: now.month)
    has_next_bill_charged = mod == 0 and Timex.diff(now, next_bill, :days) == 0

    if has_next_bill_charged,
      do: next_bill,
      else:
        first_bill
        |> Timex.shift(weeks: difference_in_weeks + (cycle_amount - mod))
        |> (&if(Timex.compare(&1, now) == -1,
              do: Timex.add(&1, Timex.Duration.from_days(cycle_amount * 30)),
              else: &1
            )).()

    # now = Timex.today()
    # difference_in_weeks = Timex.diff(now, first_bill, :weeks)
    # mod = rem(difference_in_weeks, cycle_amount)

    # is_next_bill_today = mod == 0 and Timex.diff(now, first_bill) >= 0

    # if is_next_bill_today,
    #   do: now,
    #   else:
    #     first_bill
    #     |> Timex.add(Timex.Duration.from_weeks(difference_in_weeks + (cycle_amount - mod)))
    #     |> (&if(Timex.compare(&1, now) == -1,
    #           do: Timex.add(&1, Timex.Duration.from_weeks(cycle_amount)),
    #           else: &1
    #         )).()
  end

  def next_billing_for(
        %Subscription{
          cycle_period: "month",
          first_bill: first_bill,
          cycle_amount: cycle_amount
        },
        now
      ) do
    difference_in_months = Timex.diff(now, first_bill, :months)
    mod = rem(difference_in_months, cycle_amount)
    is_same_day = mod == 0 and now.day == first_bill.day

    if is_same_day,
      do: now,
      else:
        first_bill
        |> Timex.shift(months: difference_in_months + (cycle_amount - mod))
  end

  def next_billing_for(
        %Subscription{
          cycle_period: "year",
          first_bill: first_bill,
          cycle_amount: cycle_amount
        },
        now
      ) do
    difference_in_years = Timex.diff(now, first_bill, :years)
    mod = rem(difference_in_years, cycle_amount)
    is_same_day = mod == 0 and now.day == first_bill.day and now.month == first_bill.month

    if is_same_day,
      do: now,
      else:
        first_bill
        |> Timex.shift(years: difference_in_years + (cycle_amount - mod))
  end

  defp where_user_query(query, %User{id: user_id}) do
    from e in query, where: e.created_by == ^user_id
  end

  defp get_subscriptions_count() do
    from(l in List,
      join: s in assoc(l, :subscriptions),
      group_by: l.id,
      select: {l.id, count(s.id)}
    )
    |> Repo.all()
    |> Enum.into(%{})
  end
end
