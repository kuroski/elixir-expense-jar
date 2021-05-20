defmodule ExpenseJarWeb.ListLive.Show do
  use ExpenseJarWeb, :live_view

  alias ExpenseJar.Finance
  alias ExpenseJar.Finance.Subscription
  alias ExpenseJar.Accounts.User

  @impl true
  def mount(%{"list_id" => list_id}, session, socket) do
    ExpenseJarWeb.Endpoint.subscribe(topic(list_id))
    {:ok, assign_defaults(session, socket)}
  end

  @impl true
  def handle_params(%{"list_id" => id} = params, _, %{assigns: %{current_user: %User{}}} = socket) do
    {:noreply,
     socket
     |> assign(:list, Finance.get_user_list!(socket.assigns.current_user, id))
     |> apply_action(socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    subscription = Finance.get_subscription!(id)
    {:ok, _} = Finance.delete_subscription(subscription)

    ExpenseJarWeb.Endpoint.broadcast_from(
      self(),
      topic(subscription.list_id),
      "subscription:deleted",
      subscription
    )

    {:noreply, assign(socket, :list, Finance.get_user_list!(socket.assigns.current_user, id))}
  end

  @impl true
  def handle_info(
        %{topic: message_topic, event: "subscription:updated", payload: subscription},
        socket
      ),
      do: handle_subscription_event(%{topic: message_topic, payload: subscription}, socket)

  @impl true
  def handle_info(
        %{topic: message_topic, event: "subscription:created", payload: subscription},
        socket
      ),
      do: handle_subscription_event(%{topic: message_topic, payload: subscription}, socket)

  @impl true
  def handle_info(
        %{topic: message_topic, event: "subscription:deleted", payload: subscription},
        socket
      ),
      do: handle_subscription_event(%{topic: message_topic, payload: subscription}, socket)

  def topic(list_id) do
    "list:#{list_id}"
  end

  def cycle_str(period, amount) do
    case amount do
      0 -> "0 #{period}"
      1 -> "#{period}"
      amount -> "#{amount} #{period}s"
    end
  end

  def price_str(price), do: Money.to_string(price, symbol: true)

  def next_bill(%Subscription{} = subscription) do
    next_billing = Finance.next_billing_for(subscription)
    {:ok, relative_str} = next_billing |> Timex.format("{relative}", :relative)

    [next_billing, relative_str]
  end

  defp handle_subscription_event(%{topic: message_topic, payload: subscription}, socket) do
    cond do
      topic(subscription.list_id) == message_topic ->
        {:noreply,
         assign(
           socket,
           :list,
           Finance.get_user_list!(socket.assigns.current_user, subscription.list_id)
         )}

      true ->
        {:noreply, socket}
    end
  end

  defp apply_action(socket, :edit, %{"list_id" => _id, "subscription_id" => id}) do
    socket
    |> assign(:page_title, "Edit Subscription")
    |> assign(:subscription, Finance.get_subscription!(id))
  end

  defp apply_action(socket, :new, %{"list_id" => _id}) do
    socket
    |> assign(:page_title, "New Subscription")
    |> assign(:subscription, %Subscription{})
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:subscription, nil)
  end
end
