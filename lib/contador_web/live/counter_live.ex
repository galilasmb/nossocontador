defmodule ContadorWeb.CounterLive do
  use ContadorWeb, :live_view

  alias Contador.{Repo, CounterValue}
  import Ecto.Query, except: [update: 3]

  def mount(params, _session, socket) do
    locale = get_locale_from_params(params)
    Gettext.put_locale(ContadorWeb.Gettext, locale)

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

    {:ok,
     assign(socket,
       count: last_value,
       last_five: last_five,
       locale: locale
     )}
  end

  def handle_event("toggle_locale", _params, socket) do
    new_locale = if socket.assigns.locale == "pt", do: "en", else: "pt"
    Gettext.put_locale(ContadorWeb.Gettext, new_locale)

    {:noreply, push_navigate(socket, to: ~p"/contador?locale=#{new_locale}")}
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

  defp get_locale_from_params(%{"locale" => "en"}), do: "en"
  defp get_locale_from_params(_), do: "pt"

  def render(assigns) do
    Gettext.put_locale(ContadorWeb.Gettext, assigns.locale)
    ~H"""
    <div class="flex flex-col items-center justify-center min-h-screen bg-gray-100 space-y-8">

      <h1 class="text-5xl font-bold text-gray-800"><%= gettext("Contador") %></h1>

      <div
        id="counter-display"
        phx-hook="CounterEffect"
        class="text-6xl font-mono text-blue-600"
        data-message={gettext("O contador agora é: %{count}", count: @count)}
      >
        <%= @count %>
      </div>

      <div class="space-x-4">
        <button
          phx-click="dec"
          class="px-6 py-3 bg-red-500 hover:bg-red-600 text-white font-semibold rounded-lg shadow">
          <%= gettext("Diminuir") %>
        </button>

        <button
          phx-click="inc"
          class="px-6 py-3 bg-green-500 hover:bg-green-600 text-white font-semibold rounded-lg shadow">
          <%= gettext("Aumentar") %>
        </button>

        <button
          phx-click="save"
          class="px-6 py-3 bg-blue-500 hover:bg-blue-600 text-white font-semibold rounded-lg shadow">
          <%= gettext("Salvar") %>
        </button>
      </div>

      <div class="w-full max-w-md bg-white p-4 rounded-lg shadow">
        <h2 class="text-xl font-semibold mb-4"><%= gettext("Últimos 5 valores salvos") %></h2>
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
end
