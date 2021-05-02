defmodule ExpenseJarWeb.AuthController do
  use ExpenseJarWeb, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias ExpenseJar.Accounts

  require Logger

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    Logger.error fails
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Accounts.upsert_user(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:user_id, user.id)
        |> put_session(:token, auth.credentials.token)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> assign(:ueberauth_failure, nil)
        |> callback(%{})
    end
  end
end
