defmodule ExpenseJarWeb.SubscriptionLive.Show do
  use ExpenseJarWeb, :live_view

  alias ExpenseJar.Jar

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:subscription, Jar.get_subscription!(id))}
  end

  defp page_title(:show), do: "Show Subscription"
  defp page_title(:edit), do: "Edit Subscription"
end
