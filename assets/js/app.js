import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

let Hooks = {}
Hooks.CounterEffect = {
  updated() {
    let countElement = this.el

    countElement.classList.add("scale-125", "transition", "duration-300")
    setTimeout(() => countElement.classList.remove("scale-125"), 300)

    let msg = countElement.dataset.message || `O contador agora é: ${countElement.innerText}`

    let toast = document.createElement("div")
    toast.innerText = msg
    toast.style.position = "fixed"
    toast.style.bottom = "20px"
    toast.style.right = "20px"
    toast.style.background = "rgba(0, 0, 0, 0.8)"
    toast.style.color = "#fff"
    toast.style.padding = "10px 15px"
    toast.style.borderRadius = "8px"
    toast.style.fontSize = "14px"
    toast.style.zIndex = "9999"
    document.body.appendChild(toast)

    setTimeout(() => toast.remove(), 2000)
  }
}


let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: Hooks
})

// Barra de progresso
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

liveSocket.connect()
window.liveSocket = liveSocket


window.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("[data-locale-toggle]").forEach((btn) => {
    btn.addEventListener("click", () => {
      const currentLocale = document.documentElement.lang || "pt"
      const nextLocale = currentLocale === "pt" ? "en" : "pt"
      const url = new URL(window.location)
      url.searchParams.set("locale", nextLocale)
      window.location.href = url.toString()
    })
  })
})
