defmodule ExpenseJarWeb.ListController do
  use ExpenseJarWeb, :controller

  alias ExpenseJar.Finance
  alias ExpenseJar.Finance.List
  alias ExpenseJar.Accounts.User

  def index(conn, _params, current_user) do
    lists = Finance.list_user_lists(current_user)
    render(conn, "index.html", lists: lists)
  end

  def new(conn, _params, _current_user) do
    changeset = Finance.change_list(%List{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"list" => list_params}, current_user) do
    case Finance.create_list(current_user, list_params) do
      {:ok, list} ->
        conn
        |> put_flash(:info, "List created successfully.")
        |> redirect(to: Routes.list_path(conn, :show, list))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}, _current_user) do
    list = Finance.get_list!(id)
    changeset = Finance.change_list(list)
    render(conn, "edit.html", list: list, changeset: changeset)
  end

  def update(conn, %{"id" => id, "list" => list_params}, _current_user) do
    list = Finance.get_list!(id)

    case Finance.update_list(list, list_params) do
      {:ok, _list} ->
        conn
        |> put_flash(:info, "List updated successfully.")
        |> redirect(to: Routes.list_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", list: list, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user) do
    list = Finance.get_list!(id)
    {:ok, _list} = Finance.delete_list(list)

    conn
    |> put_flash(:info, "List deleted successfully.")
    |> redirect(to: Routes.list_path(conn, :index))
  end

  def action(%{assigns: %{current_user: %User{}}} = conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end
end
