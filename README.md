# Nosso Contador

**Nosso Contador** is a simple Phoenix LiveView application that allows users to increase or decrease a counter value in real time. The current counter value is persisted in the `counter_values` table within the `contador_dev` database.

Locale management is handled by a custom Plug `ContadorWeb.Plugs.Locale`, which reads the locale from the query params (`?locale=pt` or `?locale=en`), session, or browser headers, and sets it for backend translations using `Gettext`.

## Getting Started

To start your Phoenix server:

1. Install dependencies:

```bash
mix setup
````

2. Start the Phoenix server:

```bash
mix phx.server
```

Or with IEx:

```bash
iex -S mix phx.server
```

Visit [`http://localhost:4000`](http://localhost:4000) from your browser.

## Features

* Real-time counter update using Phoenix LiveView.
* Counter value is persisted in the `counter_values` table of the `contador_dev` database.
* Internationalization (i18n) support using `Gettext`.
* Locale selection handled via URL query parameter, session, or browser settings.
* Language toggle button with flag icons in the UI (Portuguese / English).
* Notification message ("The counter is now: ...") displayed via JavaScript Hook with translated content.
* List the last five counter values.

## Project Structure

* `lib/contador_web/plugs/locale.ex`: Plug responsible for locale detection and setting.
* `lib/contador_web/live/counter_live.ex`: LiveView handling the counter logic and locale.
* `assets/js/app.js`: JavaScript hooks including translated notification message.
* `priv/gettext/`: Translation files (`.po`) for Portuguese and English.
* `priv/repo/migrations/`: Database migrations creating the `counter_values` table.
* Layout includes language toggle button with corresponding flag icons.

## Production

Ready to deploy? See the [Phoenix deployment guide](https://hexdocs.pm/phoenix/deployment.html).

## Learn More

* [Phoenix Official Website](https://www.phoenixframework.org/)
* [Phoenix Guides](https://hexdocs.pm/phoenix/overview.html)
* [Phoenix Documentation](https://hexdocs.pm/phoenix)
* [Elixir Forum - Phoenix Section](https://elixirforum.com/c/phoenix-forum)
* [Phoenix GitHub Repository](https://github.com/phoenixframework/phoenix)
