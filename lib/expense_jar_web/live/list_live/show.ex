defmodule ExpenseJarWeb.ListLive.Show do
  use ExpenseJarWeb, :live_view

  alias ExpenseJar.Finance
  alias ExpenseJar.Accounts.User

  @impl true
  def mount(%{"id" => list_id}, session, socket) do
    ExpenseJarWeb.Endpoint.subscribe(topic(list_id))
    {:ok, assign_defaults(session, socket)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, %{assigns: %{current_user: %User{}}} = socket) do
    {:noreply,
     socket
     |> assign(:list, Finance.get_user_list!(socket.assigns.current_user, id))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    subscription = Finance.get_subscription!(id)
    {:ok, _} = Finance.delete_subscription(subscription)

    ExpenseJarWeb.Endpoint.broadcast_from(self(), topic(subscription.list_id), "subscription:deleted", subscription)

    {:noreply, assign(socket, :list, Finance.get_user_list!(socket.assigns.current_user, id))}
  end

  @impl true
  def handle_info(
        %{topic: message_topic, event: "subscription:updated", payload: subscription},
        socket
      ) do
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

  @impl true
  def handle_info(
        %{topic: message_topic, event: "subscription:created", payload: subscription},
        socket
      ) do
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

  @impl true
  def handle_info(
        %{topic: message_topic, event: "subscription:deleted", payload: subscription},
        socket
      ) do
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
  def topic(list_id) do
    "list:#{list_id}"
  end
end
