defmodule ExpenseJarWeb.UserSettingsController do
  use ExpenseJarWeb, :controller

  # alias ExpenseJar.Accounts
  # alias ExpenseJarWeb.UserAuth

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def update(conn, %{"action" => "update_email"} = _params) do
    conn
    # %{"current_password" => password, "user" => user_params} = params
    # user = conn.assigns.current_user

    # case Accounts.apply_user_email(user, password, user_params) do
    #   {:ok, applied_user} ->
    #     Accounts.deliver_update_email_instructions(
    #       applied_user,
    #       user.email,
    #       &Routes.user_settings_url(conn, :confirm_email, &1)
    #     )

    #     conn
    #     |> put_flash(
    #       :info,
    #       "A link to confirm your email change has been sent to the new address."
    #     )
    #     |> redirect(to: Routes.user_settings_path(conn, :edit))

    #   {:error, changeset} ->
    #     render(conn, "edit.html", email_changeset: changeset)
    # end
  end

  def update(conn, %{"action" => "update_password"} = _params) do
    conn
    # %{"current_password" => password, "user" => user_params} = params
    # user = conn.assigns.current_user

    # case Accounts.update_user_password(user, password, user_params) do
    #   {:ok, user} ->
    #     conn
    #     |> put_flash(:info, "Password updated successfully.")
    #     |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit))
    #     |> UserAuth.log_in_user(user)

    #   {:error, changeset} ->
    #     render(conn, "edit.html", password_changeset: changeset)
    # end
  end
end
