defmodule ExpenseJarWeb.ListLiveTest do
  use ExpenseJarWeb.ConnCase

  import Phoenix.LiveViewTest

  alias ExpenseJar.Finance

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp fixture(:list) do
    {:ok, list} = Finance.create_list(@create_attrs)
    list
  end

  defp create_list(_) do
    list = fixture(:list)
    %{list: list}
  end

  describe "Show" do
    setup [:create_list]

    test "displays list", %{conn: conn, list: list} do
      {:ok, _show_live, html} = live(conn, Routes.list_show_path(conn, :show, list))

      assert html =~ "Show List"
    end

    test "updates list within modal", %{conn: conn, list: list} do
      {:ok, show_live, _html} = live(conn, Routes.list_show_path(conn, :show, list))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit List"

      assert_patch(show_live, Routes.list_show_path(conn, :edit, list))

      assert show_live
             |> form("#list-form", list: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#list-form", list: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.list_show_path(conn, :show, list))

      assert html =~ "List updated successfully"
    end
  end
end
