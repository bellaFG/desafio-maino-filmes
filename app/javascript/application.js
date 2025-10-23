// app/javascript/application.js

import "@hotwired/turbo-rails"
import "controllers"
import * as ActiveStorage from "@rails/activestorage"

ActiveStorage.start()

function initFilterToggle() {
    const toggleBtn = document.getElementById("toggle-filter")
    const panel = document.getElementById("filter-panel")

    if (!toggleBtn || !panel) return

    if (toggleBtn.dataset.initialized === "true") return
    toggleBtn.dataset.initialized = "true"

    toggleBtn.addEventListener("click", () => {
        panel.style.display =
            panel.style.display === "none" || panel.style.display === ""
                ? "block"
                : "none"
    })
}

document.addEventListener("turbo:load", initFilterToggle)
document.addEventListener("DOMContentLoaded", initFilterToggle)
