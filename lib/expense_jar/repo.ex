defmodule ExpenseJar.Repo do
  use Ecto.Repo,
    otp_app: :expense_jar,
    adapter: Ecto.Adapters.Postgres
end
