function initFetchAI() {
  console.log("🤖 fetch_ai.js inicializado!");

  const fetchBtn = document.getElementById("fetch-ai-btn");
  if (!fetchBtn) return;

  if (fetchBtn.dataset.aiInitialized === "true") return;
  fetchBtn.dataset.aiInitialized = "true";

  fetchBtn.addEventListener("click", async () => {
    const titleInput = document.getElementById("movie_title");
    if (!titleInput || !titleInput.value.trim()) {
      alert("Digite um título antes de buscar!");
      return;
    }

    fetchBtn.disabled = true;
    const originalText = fetchBtn.textContent;
    fetchBtn.textContent = "🤖 Buscando...";

    try {
      const response = await fetch(
        `/movies/fetch_movie_data?title=${encodeURIComponent(titleInput.value)}`
      );

      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`Erro HTTP ${response.status}: ${errorText}`);
      }

      const data = await response.json();
      if (data.error) {
        alert(data.error);
        return;
      }

      // Preenche campos
      const map = {
        title: "movie_title",
        synopsis: "movie_synopsis",
        year: "movie_year",
        duration: "movie_duration",
        director: "movie_director",
      };
      Object.entries(map).forEach(([key, id]) => {
        const field = document.getElementById(id);
        if (field && data[key]) field.value = data[key];
      });

      // ----- 🔽 Categoria -----
      if (data.category) {
        const normalize = (str) =>
          str
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .trim()
            .toLowerCase();
        const normalizedAI = normalize(data.category);

        const checkboxes = document.querySelectorAll("input[name='movie[category_ids][]']");
        let existingCategory = null;

        checkboxes.forEach((cb) => {
          const parent = cb.closest(".form-check");
          if (!parent) return;

          // Captura texto puro (sem botões)
          const rawText = Array.from(parent.childNodes)
            .filter((n) => n.nodeType === Node.TEXT_NODE)
            .map((n) => n.textContent)
            .join(" ")
            .trim();

          const labelText = normalize(rawText);
          if (labelText === normalizedAI) {
            existingCategory = cb;
          }
        });

        if (existingCategory) {
          existingCategory.checked = true;
        } else {
          // Cria nova categoria se não existir
          const locale = (window.location.pathname.match(/^\/(pt|en)\b/) || [])[1] || "pt";
          const endpoint = "/" + locale + "/categories";

          const resp = await fetch(endpoint, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
            },
            body: JSON.stringify({ category: { name: data.category.trim() } }),
          });

          const cat = await resp.json();
          if (cat.id) {
            const categoriesList = document.getElementById("categories-list");
            const newDiv = document.createElement("div");
            newDiv.className = "form-check";
            newDiv.setAttribute("data-category-id", cat.id);

            const checkbox = document.createElement("input");
            checkbox.type = "checkbox";
            checkbox.name = "movie[category_ids][]";
            checkbox.value = cat.id;
            checkbox.checked = true;
            checkbox.className = "form-check-input";

            const textNode = document.createTextNode(" " + cat.name + " ");
            const removeBtn = document.createElement("button");
            removeBtn.type = "button";
            removeBtn.className = "btn-remove-category";
            removeBtn.title = "Remover";
            removeBtn.style.marginLeft = "8px";
            removeBtn.textContent = "✕";
            removeBtn.onclick = async (e) => {
              e.preventDefault();
              await fetch("/" + locale + "/categories/" + cat.id, {
                method: "DELETE",
                headers: {
                  "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
                },
              });
              newDiv.remove();
            };

            newDiv.appendChild(checkbox);
            newDiv.appendChild(textNode);
            newDiv.appendChild(removeBtn);
            categoriesList.appendChild(newDiv);
          }
        }
      }

      // ----- 🔽 Tags -----
      if (Array.isArray(data.tags) && data.tags.length > 0) {
        const tagInput = document.getElementById("movie_tags");
        if (tagInput) tagInput.value = data.tags.join(", ");
      }

      console.log("✅ Dados da IA aplicados com sucesso!", data);
    } catch (error) {
      console.error("💥 Erro ao buscar dados da IA:", error);
      alert("Ocorreu um erro ao buscar dados da IA: " + error.message);
    } finally {
      fetchBtn.disabled = false;
      fetchBtn.textContent = originalText;
    }
  });
}

document.addEventListener("turbo:load", initFetchAI);
export {};
