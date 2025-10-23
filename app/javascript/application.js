import "@hotwired/turbo-rails"
import "@rails/ujs"
import "controllers"
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

function initFilterToggle() {
    const toggleBtn = document.getElementById("toggle-filter")
    const panel = document.getElementById("filter-panel")

    if (!toggleBtn || !panel) return

    if (toggleBtn.dataset.initialized) return
    toggleBtn.dataset.initialized = true

    toggleBtn.addEventListener("click", () => {

        if (panel.style.display === "none" || panel.style.display === "") {
            panel.style.display = "block"
        } else {
            panel.style.display = "none"
        }
    })
}

document.addEventListener("turbo:load", initFilterToggle)
document.addEventListener("DOMContentLoaded", initFilterToggle)
