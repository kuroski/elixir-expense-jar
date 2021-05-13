defmodule ExpenseJar.Finance do
  @moduledoc """
  The Finance context.
  """

  import Ecto.Query, warn: false
  alias ExpenseJar.Repo
  alias ExpenseJar.Accounts.User

  alias ExpenseJar.Finance.List

  @doc """
  Returns the list of lists.

  ## Examples

      iex> list_lists()
      [%List{}, ...]

  """
  def list_lists() do
    subscription_count = get_subscriptions_count()

    Repo.all(List)
    |> Enum.map(&%{&1 | subscription_count: subscription_count[&1.id] || 0})
  end

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

      iex> get_list!(123)
      %List{}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_list!(%User{} = user, id),
    do:
      List
      |> where_user_query(user)
      # Example of anonymous function in pipe
      |> (&(from(l in &1, left_join: s in assoc(l, :subscriptions), preload: [subscriptions: s]))).()
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
