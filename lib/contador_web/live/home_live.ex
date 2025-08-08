defmodule ContadorWeb.HomeLive do
  use ContadorWeb, :live_view

  def mount(params, _session, socket) do
    locale = get_locale_from_params(params)
    Gettext.put_locale(ContadorWeb.Gettext, locale)

    {:ok, assign(socket, locale: locale, message: gettext("Bem-vindo!"))}
  end

  def handle_event("toggle_locale", _params, socket) do
    new_locale = if socket.assigns.locale == "pt", do: "en", else: "pt"
    Gettext.put_locale(ContadorWeb.Gettext, new_locale)

    {:noreply, push_navigate(socket, to: ~p"/?locale=#{new_locale}")}
  end

  defp get_locale_from_params(%{"locale" => "en"}), do: "en"
  defp get_locale_from_params(_), do: "pt"

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center min-h-screen bg-gray-100 p-6 space-y-6">
      <h1 class="text-5xl font-bold text-gray-800"><%= gettext("Nosso Contador") %></h1>
      <p class="text-lg text-gray-700"><%= @message %></p>

      <.link
        navigate={~p"/contador?locale=#{@locale}"}
        class="px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-lg font-semibold shadow"
      >
        <%= gettext("Ir para Contador") %>
      </.link>
    </div>
    """
  end
end
