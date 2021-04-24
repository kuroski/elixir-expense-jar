defmodule ExpenseJarWeb.SubscriptionLive.FormComponent do
  use ExpenseJarWeb, :live_component

  alias ExpenseJar.Jar

  @impl true
  def update(%{subscription: subscription} = assigns, socket) do
    changeset = Jar.change_subscription(subscription)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"subscription" => subscription_params}, socket) do
    changeset =
      socket.assigns.subscription
      |> Jar.change_subscription(subscription_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"subscription" => subscription_params}, socket) do
    save_subscription(socket, socket.assigns.action, subscription_params)
  end

  defp save_subscription(socket, :edit, subscription_params) do
    case Jar.update_subscription(socket.assigns.subscription, subscription_params) do
      {:ok, _subscription} ->
        {:noreply,
         socket
         |> put_flash(:info, "Subscription updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_subscription(socket, :new, subscription_params) do
    case Jar.create_subscription(subscription_params) do
      {:ok, _subscription} ->
        {:noreply,
         socket
         |> put_flash(:info, "Subscription created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
