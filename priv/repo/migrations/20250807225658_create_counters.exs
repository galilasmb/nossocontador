defmodule Contador.Repo.Migrations.CreateCounters do
  use Ecto.Migration

  def change do
    create table(:counters) do
      add :value, :integer
      timestamps()
    end
  end
end
