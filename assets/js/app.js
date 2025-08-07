import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

let Hooks = {}

Hooks.CounterEffect = {
  updated() {
    let countElement = this.el

    // Efeito visual
    countElement.classList.add("scale-125", "transition", "duration-300")
    setTimeout(() => {
      countElement.classList.remove("scale-125")
    }, 300)

    // Exibir mensagem na tela
    let msg = document.createElement("div")
    msg.innerText = `O contador agora é: ${countElement.innerText}`
    msg.style.position = "fixed"
    msg.style.bottom = "20px"
    msg.style.right = "20px"
    msg.style.background = "rgba(0, 0, 0, 0.8)"
    msg.style.color = "#fff"
    msg.style.padding = "10px 15px"
    msg.style.borderRadius = "8px"
    msg.style.fontSize = "14px"
    msg.style.zIndex = "9999"
    document.body.appendChild(msg)

    // Remove a mensagem após 2 segundos
    setTimeout(() => {
      msg.remove()
    }, 1000)
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
