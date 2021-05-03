defmodule ExpenseJarWeb.ListLive.FormComponent do
  use ExpenseJarWeb, :live_component

  alias ExpenseJar.Finance

  @impl true
  def update(%{list: list, current_user: _current_user} = assigns, socket) do
    changeset = Finance.change_list(list)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    changeset =
      socket.assigns.list
      |> Finance.change_list()
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", _params, socket) do
    save_list(socket, socket.assigns.action)
  end

  defp save_list(socket, :new) do
    case Finance.create_list(socket.assigns.current_user, %{}) do
      {:ok, _list} ->
        {:noreply,
         socket
         |> put_flash(:info, "List created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
