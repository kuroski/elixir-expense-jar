defmodule ExpenseJar.FinanceTest do
  use ExpenseJar.DataCase

  alias ExpenseJar.Finance

  describe "lists" do
    alias ExpenseJar.Finance.List

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def list_fixture(attrs \\ %{}) do
      {:ok, list} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Finance.create_list()

      list
    end

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Finance.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Finance.get_list!(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      assert {:ok, %List{} = list} = Finance.create_list(@valid_attrs)
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      assert {:ok, %List{} = list} = Finance.update_list(list, @update_attrs)
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_list(list, @invalid_attrs)
      assert list == Finance.get_list!(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Finance.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Finance.change_list(list)
    end
  end

  describe "subscriptions" do
    alias ExpenseJar.Finance.Subscription

    @valid_attrs %{color: "some color", cycle_amount: 42, cycle_period: "some cycle_period", first_bill: ~D[2010-04-17], icon: "some icon", name: "some name", overview: "some overview", price: "120.5"}
    @update_attrs %{color: "some updated color", cycle_amount: 43, cycle_period: "some updated cycle_period", first_bill: ~D[2011-05-18], icon: "some updated icon", name: "some updated name", overview: "some updated overview", price: "456.7"}
    @invalid_attrs %{color: nil, cycle_amount: nil, cycle_period: nil, first_bill: nil, icon: nil, name: nil, overview: nil, price: nil}

    def subscription_fixture(attrs \\ %{}) do
      {:ok, subscription} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Finance.create_subscription()

      subscription
    end

    test "list_subscriptions/0 returns all subscriptions" do
      subscription = subscription_fixture()
      assert Finance.list_subscriptions() == [subscription]
    end

    test "get_subscription!/1 returns the subscription with given id" do
      subscription = subscription_fixture()
      assert Finance.get_subscription!(subscription.id) == subscription
    end

    test "create_subscription/1 with valid data creates a subscription" do
      assert {:ok, %Subscription{} = subscription} = Finance.create_subscription(@valid_attrs)
      assert subscription.color == "some color"
      assert subscription.cycle_amount == 42
      assert subscription.cycle_period == "some cycle_period"
      assert subscription.first_bill == ~D[2010-04-17]
      assert subscription.icon == "some icon"
      assert subscription.name == "some name"
      assert subscription.overview == "some overview"
      assert subscription.price == Decimal.new("120.5")
    end

    test "create_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_subscription(@invalid_attrs)
    end

    test "update_subscription/2 with valid data updates the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{} = subscription} = Finance.update_subscription(subscription, @update_attrs)
      assert subscription.color == "some updated color"
      assert subscription.cycle_amount == 43
      assert subscription.cycle_period == "some updated cycle_period"
      assert subscription.first_bill == ~D[2011-05-18]
      assert subscription.icon == "some updated icon"
      assert subscription.name == "some updated name"
      assert subscription.overview == "some updated overview"
      assert subscription.price == Decimal.new("456.7")
    end

    test "update_subscription/2 with invalid data returns error changeset" do
      subscription = subscription_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_subscription(subscription, @invalid_attrs)
      assert subscription == Finance.get_subscription!(subscription.id)
    end

    test "delete_subscription/1 deletes the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{}} = Finance.delete_subscription(subscription)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_subscription!(subscription.id) end
    end

    test "change_subscription/1 returns a subscription changeset" do
      subscription = subscription_fixture()
      assert %Ecto.Changeset{} = Finance.change_subscription(subscription)
    end
  end
end
