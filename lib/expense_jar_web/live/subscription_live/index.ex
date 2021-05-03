defmodule ExpenseJarWeb.SubscriptionLive.Index do
  use ExpenseJarWeb, :live_view

  alias ExpenseJar.Finance
  alias ExpenseJar.Finance.Subscription

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :subscriptions, list_subscriptions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Subscription")
    |> assign(:subscription, Finance.get_subscription!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Subscription")
    |> assign(:subscription, %Subscription{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Subscriptions")
    |> assign(:subscription, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    subscription = Finance.get_subscription!(id)
    {:ok, _} = Finance.delete_subscription(subscription)

    {:noreply, assign(socket, :subscriptions, list_subscriptions())}
  end

  defp list_subscriptions do
    Finance.list_subscriptions()
  end
end
