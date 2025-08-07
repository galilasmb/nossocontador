defmodule ContadorWeb.HomeLive do
  use ContadorWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, message: "Bem-vindo!")}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center min-h-screen bg-gray-100 p-6 space-y-6">
      <h1 class="text-5xl font-bold text-gray-800">Nosso Contador</h1>
      <p class="text-lg text-gray-700"><%= @message %></p>

      <.link
        navigate={~p"/contador"}
        class="px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-lg font-semibold shadow"
      >
        Ir para Contador
      </.link>
    </div>
    """
  end
end
