defmodule ExpenseJar.FinanceTest do
  use ExpenseJar.DataCase

  alias ExpenseJar.Finance

  # describe "lists" do
  #   alias ExpenseJar.Finance.List

  #   @valid_attrs %{}
  #   @update_attrs %{}
  #   @invalid_attrs %{}

  #   def list_fixture(attrs \\ %{}) do
  #     {:ok, list} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Finance.create_list()

  #     list
  #   end

  #   test "get_list!/1 returns the list with given id" do
  #     list = list_fixture()
  #     assert Finance.get_list!(list.id) == list
  #   end

  #   test "create_list/1 with valid data creates a list" do
  #     assert {:ok, %List{} = list} = Finance.create_list(@valid_attrs)
  #   end

  #   test "create_list/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Finance.create_list(@invalid_attrs)
  #   end

  #   test "update_list/2 with valid data updates the list" do
  #     list = list_fixture()
  #     assert {:ok, %List{} = list} = Finance.update_list(list, @update_attrs)
  #   end

  #   test "update_list/2 with invalid data returns error changeset" do
  #     list = list_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Finance.update_list(list, @invalid_attrs)
  #     assert list == Finance.get_list!(list.id)
  #   end

  #   test "delete_list/1 deletes the list" do
  #     list = list_fixture()
  #     assert {:ok, %List{}} = Finance.delete_list(list)
  #     assert_raise Ecto.NoResultsError, fn -> Finance.get_list!(list.id) end
  #   end

  #   test "change_list/1 returns a list changeset" do
  #     list = list_fixture()
  #     assert %Ecto.Changeset{} = Finance.change_list(list)
  #   end
  # end

  describe "subscriptions" do
    alias ExpenseJar.Finance.Subscription

    @valid_attrs %Subscription{
      color: "some color",
      cycle_amount: 42,
      cycle_period: "month",
      first_bill: ~D[2010-04-17],
      icon: "some icon",
      name: "some name",
      overview: "some overview",
      price: "120.5"
    }

    # @update_attrs %{
    #   color: "some updated color",
    #   cycle_amount: 43,
    #   cycle_period: "some updated cycle_period",
    #   first_bill: ~D[2011-05-18],
    #   icon: "some updated icon",
    #   name: "some updated name",
    #   overview: "some updated overview",
    #   price: "456.7"
    # }
    # @invalid_attrs %{
    #   color: nil,
    #   cycle_amount: nil,
    #   cycle_period: nil,
    #   first_bill: nil,
    #   icon: nil,
    #   name: nil,
    #   overview: nil,
    #   price: nil
    # }

    # def subscription_fixture(attrs \\ %{}) do
    #   {:ok, subscription} =
    #     attrs
    #     |> Enum.into(@valid_attrs)
    #     |> Finance.create_subscription()

    #   subscription
    # end

    # test "list_subscriptions/0 returns all subscriptions" do
    #   subscription = subscription_fixture()
    #   assert Finance.list_subscriptions() == [subscription]
    # end

    # test "get_subscription!/1 returns the subscription with given id" do
    #   subscription = subscription_fixture()
    #   assert Finance.get_subscription!(subscription.id) == subscription
    # end

    # test "create_subscription/1 with valid data creates a subscription" do
    #   assert {:ok, %Subscription{} = subscription} = Finance.create_subscription(@valid_attrs)
    #   assert subscription.color == "some color"
    #   assert subscription.cycle_amount == 42
    #   assert subscription.cycle_period == "some cycle_period"
    #   assert subscription.first_bill == ~D[2010-04-17]
    #   assert subscription.icon == "some icon"
    #   assert subscription.name == "some name"
    #   assert subscription.overview == "some overview"
    #   assert subscription.price == Decimal.new("120.5")
    # end

    # test "create_subscription/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Finance.create_subscription(@invalid_attrs)
    # end

    # test "update_subscription/2 with valid data updates the subscription" do
    #   subscription = subscription_fixture()

    #   assert {:ok, %Subscription{} = subscription} =
    #            Finance.update_subscription(subscription, @update_attrs)

    #   assert subscription.color == "some updated color"
    #   assert subscription.cycle_amount == 43
    #   assert subscription.cycle_period == "some updated cycle_period"
    #   assert subscription.first_bill == ~D[2011-05-18]
    #   assert subscription.icon == "some updated icon"
    #   assert subscription.name == "some updated name"
    #   assert subscription.overview == "some updated overview"
    #   assert subscription.price == Decimal.new("456.7")
    # end

    # test "update_subscription/2 with invalid data returns error changeset" do
    #   subscription = subscription_fixture()

    #   assert {:error, %Ecto.Changeset{}} =
    #            Finance.update_subscription(subscription, @invalid_attrs)

    #   assert subscription == Finance.get_subscription!(subscription.id)
    # end

    # test "delete_subscription/1 deletes the subscription" do
    #   subscription = subscription_fixture()
    #   assert {:ok, %Subscription{}} = Finance.delete_subscription(subscription)
    #   assert_raise Ecto.NoResultsError, fn -> Finance.get_subscription!(subscription.id) end
    # end

    # test "change_subscription/1 returns a subscription changeset" do
    #   subscription = subscription_fixture()
    #   assert %Ecto.Changeset{} = Finance.change_subscription(subscription)
    # end

    test "daily next_billing_for/2 returns next date for subscription" do
      daily_subscription = @valid_attrs

      daily_subscription = %{
        daily_subscription
        | cycle_period: "day",
          cycle_amount: 1,
          first_bill: ~D[2020-01-10]
      }

      assert Finance.next_billing_for(daily_subscription, ~D[2021-01-10]) == ~D[2021-01-11]
      assert Finance.next_billing_for(daily_subscription, ~D[2021-01-05]) == ~D[2021-01-06]
      assert Finance.next_billing_for(daily_subscription, ~D[2021-01-15]) == ~D[2021-01-16]

      every_two_days_subscription = %{
        daily_subscription
        | cycle_period: "day",
          cycle_amount: 2,
          first_bill: ~D[2020-01-10]
      }

      assert Finance.next_billing_for(every_two_days_subscription, ~D[2021-01-10]) ==
               ~D[2021-01-12]

      assert Finance.next_billing_for(every_two_days_subscription, ~D[2021-01-05]) ==
               ~D[2021-01-07]

      assert Finance.next_billing_for(every_two_days_subscription, ~D[2021-01-15]) ==
               ~D[2021-01-17]

      same_day_subscription = %{
        daily_subscription
        | cycle_period: "day",
          cycle_amount: 1,
          first_bill: ~D[2021-01-10]
      }

      assert Finance.next_billing_for(same_day_subscription, ~D[2021-01-10]) ==
               ~D[2021-01-11]
    end

    test "weekly next_billing_for/2 returns next date for subscription" do
      weekly_subscription = @valid_attrs

      weekly_subscription = %{
        weekly_subscription
        | cycle_period: "week",
          cycle_amount: 1,
          first_bill: ~D[2021-01-01]
      }

      assert Finance.next_billing_for(weekly_subscription, ~D[2021-01-08]) == ~D[2021-01-08]
      assert Finance.next_billing_for(weekly_subscription, ~D[2021-01-05]) == ~D[2021-01-08]
      assert Finance.next_billing_for(weekly_subscription, ~D[2021-01-10]) == ~D[2021-01-15]

      every_two_weeks_subscription = %{
        weekly_subscription
        | cycle_period: "week",
          cycle_amount: 2,
          first_bill: ~D[2021-01-01]
      }

      assert Finance.next_billing_for(every_two_weeks_subscription, ~D[2021-01-15]) ==
               ~D[2021-01-15]

      assert Finance.next_billing_for(every_two_weeks_subscription, ~D[2021-01-10]) ==
               ~D[2021-01-15]

      assert Finance.next_billing_for(every_two_weeks_subscription, ~D[2021-01-18]) ==
               ~D[2021-01-29]

      same_week_subscription = %{
        weekly_subscription
        | cycle_period: "week",
          cycle_amount: 1,
          first_bill: ~D[2021-01-10]
      }

      assert Finance.next_billing_for(same_week_subscription, ~D[2021-01-10]) ==
               ~D[2021-01-10]
    end

    test "monthly next_billing_for/2 returns next date for subscription" do
      monthly_subscription = @valid_attrs

      monthly_subscription = %{
        monthly_subscription
        | cycle_period: "month",
          cycle_amount: 1,
          first_bill: ~D[2020-01-10]
      }

      assert Finance.next_billing_for(monthly_subscription, ~D[2021-01-10]) == ~D[2021-01-10]
      assert Finance.next_billing_for(monthly_subscription, ~D[2021-01-05]) == ~D[2021-01-10]
      assert Finance.next_billing_for(monthly_subscription, ~D[2021-01-15]) == ~D[2021-02-10]

      every_two_months_subscription = %{
        monthly_subscription
        | cycle_period: "month",
          cycle_amount: 2,
          first_bill: ~D[2020-01-10]
      }

      assert Finance.next_billing_for(every_two_months_subscription, ~D[2021-01-10]) ==
               ~D[2021-01-10]

      assert Finance.next_billing_for(every_two_months_subscription, ~D[2021-01-05]) ==
               ~D[2021-01-10]

      assert Finance.next_billing_for(every_two_months_subscription, ~D[2021-01-15]) ==
               ~D[2021-03-10]

      same_month_subscription = %{
        monthly_subscription
        | cycle_period: "month",
          cycle_amount: 1,
          first_bill: ~D[2021-01-10]
      }

      assert Finance.next_billing_for(same_month_subscription, ~D[2021-01-10]) ==
               ~D[2021-01-10]
    end

    test "yearly next_billing_for/2 returns next date for subscription" do
      yearly_subscription = @valid_attrs

      yearly_subscription = %{
        yearly_subscription
        | cycle_period: "year",
          cycle_amount: 1,
          first_bill: ~D[2020-01-10]
      }

      assert Finance.next_billing_for(yearly_subscription, ~D[2021-01-10]) == ~D[2021-01-10]
      assert Finance.next_billing_for(yearly_subscription, ~D[2021-01-05]) == ~D[2021-01-10]
      assert Finance.next_billing_for(yearly_subscription, ~D[2021-01-15]) == ~D[2022-01-10]

      every_two_years_subscription = %{
        yearly_subscription
        | cycle_period: "year",
          cycle_amount: 2,
          first_bill: ~D[2020-01-10]
      }

      assert Finance.next_billing_for(every_two_years_subscription, ~D[2022-01-10]) ==
               ~D[2022-01-10]

      assert Finance.next_billing_for(every_two_years_subscription, ~D[2021-01-05]) ==
               ~D[2022-01-10]

      assert Finance.next_billing_for(every_two_years_subscription, ~D[2022-01-15]) ==
               ~D[2024-01-10]

      same_year_subscription = %{
        yearly_subscription
        | cycle_period: "year",
          cycle_amount: 1,
          first_bill: ~D[2021-01-10]
      }

      assert Finance.next_billing_for(same_year_subscription, ~D[2021-01-10]) ==
               ~D[2021-01-10]
    end
  end
end
