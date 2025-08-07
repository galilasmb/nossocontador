defmodule ContadorWeb.CounterLive do
  use ContadorWeb, :live_view

  alias Contador.{Repo, CounterValue}
  import Ecto.Query, except: [update: 3]

  def mount(_params, _session, socket) do
    last_value =
      CounterValue
      |> order_by(desc: :inserted_at)
      |> limit(1)
      |> Repo.one()
      |> case do
        nil -> 0
        %CounterValue{value: val} -> val
      end

    last_five =
      CounterValue
      |> order_by(desc: :inserted_at)
      |> limit(5)
      |> Repo.all()

    {:ok, assign(socket, count: last_value, last_five: last_five)}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center min-h-screen bg-gray-100 space-y-8">
      <h1 class="text-5xl font-bold text-gray-800">Contador</h1>

      <!-- Hook aplicado no contador -->
      <div id="counter-display" phx-hook="CounterEffect" class="text-6xl font-mono text-blue-600">
        <%= @count %>
      </div>

      <div class="space-x-4">
        <button
          phx-click="dec"
          class="px-6 py-3 bg-red-500 hover:bg-red-600 text-white font-semibold rounded-lg shadow">
          -
        </button>

        <button
          phx-click="inc"
          class="px-6 py-3 bg-green-500 hover:bg-green-600 text-white font-semibold rounded-lg shadow">
          +
        </button>

        <button
          phx-click="save"
          class="px-6 py-3 bg-blue-500 hover:bg-blue-600 text-white font-semibold rounded-lg shadow">
          Salvar
        </button>
      </div>

      <div class="w-full max-w-md bg-white p-4 rounded-lg shadow">
        <h2 class="text-xl font-semibold mb-4">Últimos 5 valores salvos</h2>
        <ul class="list-disc list-inside space-y-1">
          <%= for val <- @last_five do %>
            <li>
              <span class="font-mono"><%= val.value %></span>
              <span class="text-gray-500 text-sm">
                (<%= val.inserted_at |> Calendar.strftime("%d/%m/%Y %H:%M:%S") %>)
              </span>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("inc", _value, socket) do
    {:noreply, update(socket, :count, &(&1 + 1))}
  end

  def handle_event("dec", _value, socket) do
    {:noreply, update(socket, :count, &(&1 - 1))}
  end

  def handle_event("save", _value, %{assigns: %{count: count}} = socket) do
    %CounterValue{}
    |> CounterValue.changeset(%{value: count})
    |> Repo.insert()

    last_five =
      CounterValue
      |> order_by(desc: :inserted_at)
      |> limit(5)
      |> Repo.all()

    {:noreply, assign(socket, last_five: last_five)}
  end
end
