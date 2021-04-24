defmodule ExpenseJar.Jar.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :created_by, :id

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [])
    |> validate_required([])
  end
end
