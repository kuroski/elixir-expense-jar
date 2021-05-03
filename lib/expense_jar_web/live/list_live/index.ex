defmodule ExpenseJarWeb.ListLive.Index do
  use ExpenseJarWeb, :live_view

  alias ExpenseJar.Finance
  alias ExpenseJar.Finance.List

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      assign_defaults(session, socket)
      |> assign(:lists, list_lists())
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit List")
    |> assign(:list, Finance.get_list!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New List")
    |> assign(:list, %List{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Lists")
    |> assign(:list, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    list = Finance.get_list!(id)
    {:ok, _} = Finance.delete_list(list)

    {:noreply, assign(socket, :lists, list_lists())}
  end

  defp list_lists do
    Finance.list_lists()
  end
end
