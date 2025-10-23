// Configure your import map in config/importmap.rb.
// Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails"
import "controllers"
import "@rails/ujs" // <- importante para method: :delete


// Espera o Turbo carregar a página
document.addEventListener("turbo:load", () => {
    const toggleBtn = document.querySelector("#toggle-filter");
    const panel = document.querySelector("#filter-panel");

    if (!toggleBtn || !panel) return; // segurança

    toggleBtn.addEventListener("click", () => {
        panel.classList.toggle("active");
    });
});
