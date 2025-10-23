import "@hotwired/turbo-rails"
import "@rails/ujs"
import "controllers"

// Função simples pra abrir/fechar o filtro
function initFilterToggle() {
    const toggleBtn = document.getElementById("toggle-filter")
    const panel = document.getElementById("filter-panel")

    if (!toggleBtn || !panel) return

    // Evita adicionar o listener mais de uma vez
    if (toggleBtn.dataset.initialized) return
    toggleBtn.dataset.initialized = true

    toggleBtn.addEventListener("click", () => {
        // alterna visibilidade
        if (panel.style.display === "none" || panel.style.display === "") {
            panel.style.display = "block"
        } else {
            panel.style.display = "none"
        }
    })
}

// Roda tanto em turbo quanto em reload normal
document.addEventListener("turbo:load", initFilterToggle)
document.addEventListener("DOMContentLoaded", initFilterToggle)
