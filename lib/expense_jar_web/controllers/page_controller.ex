defmodule ExpenseJarWeb.PageController do
  use ExpenseJarWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
