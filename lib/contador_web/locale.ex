defmodule ContadorWeb.Plugs.Locale do
  import Plug.Conn

  @locales ~w(en pt)

  def init(default), do: default

  def call(conn, _default) do
    locale =
      conn.params["locale"] ||
        get_session(conn, :locale) ||
        get_req_header(conn, "accept-language")
        |> List.first()
        |> parse_locale()

    Gettext.put_locale(ContadorWeb.Gettext, locale)
    conn |> put_session(:locale, locale)
  end

  defp parse_locale(nil), do: "en"
  defp parse_locale(header) do
    header
    |> String.split(",")
    |> Enum.map(&String.slice(&1, 0..1))
    |> Enum.find(&(&1 in @locales)) || "en"
  end
end
