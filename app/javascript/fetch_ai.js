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

            if (data.category) {
                const checkboxes = document.querySelectorAll(
                    "input[name='movie[category_ids][]']"
                );

                let matched = false;
                checkboxes.forEach((cb) => {
                    const label = cb.parentElement.textContent.trim().toLowerCase();
                    if (label === data.category.trim().toLowerCase()) {
                        cb.checked = true;
                        matched = true;
                    } else {
                        cb.checked = false;
                    }
                });

                if (!matched) {
                    const outros = Array.from(checkboxes).find((cb) =>
                        cb.parentElement.textContent
                            .trim()
                            .toLowerCase()
                            .includes("outros")
                    );
                    if (outros) outros.checked = true;
                }
            }

            if (Array.isArray(data.tags) && data.tags.length > 0) {
                const tagInput = document.getElementById("movie_tags");
                if (tagInput) {
                    tagInput.value = data.tags.join(", ");
                }
            }

            console.log("Dados da IA aplicados com sucesso!", data);
        } catch (error) {
            console.error("Erro ao buscar dados da IA:", error);
            alert("Ocorreu um erro ao buscar dados da IA : " + error.message);
        } finally {
            fetchBtn.disabled = false;
            fetchBtn.textContent = originalText;
        }
    });
}

document.addEventListener("turbo:load", initFetchAI);
document.addEventListener("DOMContentLoaded", initFetchAI);

export { };
