defmodule ExpenseJarWeb.ListView do
  use ExpenseJarWeb, :view

  def subscription_count_str(n) do
    case n do
      0 -> "(no subscriptions)"
      1 -> "(1 subscription)"
      n -> "(#{n} subscriptions)"
    end
  end
end
