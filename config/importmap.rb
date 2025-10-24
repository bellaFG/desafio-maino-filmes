# Pin npm packages by running ./bin/importmap

pin_all_from "app/javascript", under: "/"
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@rails/activestorage", to: "activestorage.esm.js"

# Controladores Stimulus
pin_all_from "app/javascript/controllers", under: "controllers"

# ✅ Adiciona o módulo customizado
pin "fetch_ai", to: "fetch_ai.js"
