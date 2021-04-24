defmodule ExpenseJarWeb.SubscriptionLiveTest do
  use ExpenseJarWeb.ConnCase

  import Phoenix.LiveViewTest

  alias ExpenseJar.Jar

  @create_attrs %{color: "some color", cycle_amount: 42, cycle_period: "some cycle_period", first_bill: ~D[2010-04-17], icon: "some icon", name: "some name", overview: "some overview", price: "120.5"}
  @update_attrs %{color: "some updated color", cycle_amount: 43, cycle_period: "some updated cycle_period", first_bill: ~D[2011-05-18], icon: "some updated icon", name: "some updated name", overview: "some updated overview", price: "456.7"}
  @invalid_attrs %{color: nil, cycle_amount: nil, cycle_period: nil, first_bill: nil, icon: nil, name: nil, overview: nil, price: nil}

  defp fixture(:subscription) do
    {:ok, subscription} = Jar.create_subscription(@create_attrs)
    subscription
  end

  defp create_subscription(_) do
    subscription = fixture(:subscription)
    %{subscription: subscription}
  end

  describe "Index" do
    setup [:create_subscription]

    test "lists all subscriptions", %{conn: conn, subscription: subscription} do
      {:ok, _index_live, html} = live(conn, Routes.subscription_index_path(conn, :index))

      assert html =~ "Listing Subscriptions"
      assert html =~ subscription.color
    end

    test "saves new subscription", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.subscription_index_path(conn, :index))

      assert index_live |> element("a", "New Subscription") |> render_click() =~
               "New Subscription"

      assert_patch(index_live, Routes.subscription_index_path(conn, :new))

      assert index_live
             |> form("#subscription-form", subscription: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#subscription-form", subscription: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.subscription_index_path(conn, :index))

      assert html =~ "Subscription created successfully"
      assert html =~ "some color"
    end

    test "updates subscription in listing", %{conn: conn, subscription: subscription} do
      {:ok, index_live, _html} = live(conn, Routes.subscription_index_path(conn, :index))

      assert index_live |> element("#subscription-#{subscription.id} a", "Edit") |> render_click() =~
               "Edit Subscription"

      assert_patch(index_live, Routes.subscription_index_path(conn, :edit, subscription))

      assert index_live
             |> form("#subscription-form", subscription: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#subscription-form", subscription: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.subscription_index_path(conn, :index))

      assert html =~ "Subscription updated successfully"
      assert html =~ "some updated color"
    end

    test "deletes subscription in listing", %{conn: conn, subscription: subscription} do
      {:ok, index_live, _html} = live(conn, Routes.subscription_index_path(conn, :index))

      assert index_live |> element("#subscription-#{subscription.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#subscription-#{subscription.id}")
    end
  end

  describe "Show" do
    setup [:create_subscription]

    test "displays subscription", %{conn: conn, subscription: subscription} do
      {:ok, _show_live, html} = live(conn, Routes.subscription_show_path(conn, :show, subscription))

      assert html =~ "Show Subscription"
      assert html =~ subscription.color
    end

    test "updates subscription within modal", %{conn: conn, subscription: subscription} do
      {:ok, show_live, _html} = live(conn, Routes.subscription_show_path(conn, :show, subscription))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Subscription"

      assert_patch(show_live, Routes.subscription_show_path(conn, :edit, subscription))

      assert show_live
             |> form("#subscription-form", subscription: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#subscription-form", subscription: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.subscription_show_path(conn, :show, subscription))

      assert html =~ "Subscription updated successfully"
      assert html =~ "some updated color"
    end
  end
end
