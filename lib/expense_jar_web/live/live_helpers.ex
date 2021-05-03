defmodule ExpenseJarWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `ExpenseJarWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, ExpenseJarWeb.ListLive.FormComponent,
        id: @list.id || :new,
        action: @live_action,
        list: @list,
        return_to: Routes.list_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, ExpenseJarWeb.ModalComponent, modal_opts)
  end

  @doc """
  Assign default session variables in the connection socket.

  This function will make sure only authenticated users are able to continue.
  """
  def assign_defaults(%{"user_token" => user_token}, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        ExpenseJar.Accounts.get_user_by_session_token(user_token)
      end)

    if socket.assigns.current_user do
      socket
    else
      redirect(socket, to: "/")
    end
  end
end
