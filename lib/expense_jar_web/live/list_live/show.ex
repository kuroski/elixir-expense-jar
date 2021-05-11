defmodule ExpenseJarWeb.ListLive.Show do
  use ExpenseJarWeb, :live_view

  alias ExpenseJar.Finance

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      assign_defaults(session, socket)
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:list, Finance.get_list!(id))}
  end
end
