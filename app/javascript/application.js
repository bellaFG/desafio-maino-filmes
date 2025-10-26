import "@hotwired/turbo-rails";
import "controllers";
import * as ActiveStorage from "@rails/activestorage";

ActiveStorage.start();

function initFilterToggle() {
  console.log("Initializing filter toggle");
  const toggleBtn = document.getElementById("toggle-filter");
  const panel = document.getElementById("filter-panel");

  if (!toggleBtn || !panel) return;

  if (toggleBtn.dataset.initialized === "true") return;
  toggleBtn.dataset.initialized = "true";

  toggleBtn.addEventListener("click", () => {
    panel.classList.toggle("active");
  });
}

console.log("Setting up event listeners for filter toggle");

document.addEventListener("turbo:load", initFilterToggle);
document.addEventListener("DOMContentLoaded", initFilterToggle);

import "fetch_ai";
