// Configure your import map in config/importmap.rb. 
// Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails"
import "controllers"

// Wait for Turbo to finish loading the page
document.addEventListener("turbo:load", () => {
    const toggleBtn = document.querySelector("#toggle-filter");
    const panel = document.querySelector("#filter-panel");

    if (!toggleBtn || !panel) return; // Safe guard

    toggleBtn.addEventListener("click", () => {
        panel.classList.toggle("hidden");

        // Optional: Add a small animation effect
        if (!panel.classList.contains("hidden")) {
            panel.classList.add("fade-in");
        } else {
            panel.classList.remove("fade-in");
        }
    });
});
