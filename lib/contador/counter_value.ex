defmodule Contador.CounterValue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "counter_values" do
    field :value, :integer

    timestamps()
  end

  def changeset(counter_value, attrs) do
    counter_value
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
