// app/javascript/fetch_ai.js

// ✅ Garante que só roda quando o DOM está pronto com Turbo
document.addEventListener("turbo:load", () => {
    console.log("🤖 fetch_ai.js carregado com sucesso!");

    const fetchBtn = document.getElementById("fetch-ai-btn");
    if (!fetchBtn) return;

    // evita múltiplos listeners
    if (fetchBtn.dataset.aiInitialized === "true") return;
    fetchBtn.dataset.aiInitialized = "true";

    fetchBtn.addEventListener("click", async () => {
        const titleInput = document.getElementById("movie_title");
        if (!titleInput || !titleInput.value.trim()) {
            alert("Digite um título antes de buscar!");
            return;
        }

        try {
            const response = await fetch(
                `/movies/fetch_movie_data?title=${encodeURIComponent(titleInput.value)}`
            );

            if (!response.ok) {
                const errorText = await response.text();
                throw new Error(`Erro HTTP ${response.status}: ${errorText}`);
            }

            const data = await response.json();

            // Preenche os campos automaticamente se existirem
            const map = {
                synopsis: "movie_synopsis",
                year: "movie_year",
                duration: "movie_duration",
                director: "movie_director",
                categories: "movie_categories",
                tags: "movie_tags",
            };

            Object.entries(map).forEach(([key, id]) => {
                const field = document.getElementById(id);
                if (field) field.value = data[key] || "";
            });

            console.log("✅ Dados preenchidos automaticamente com sucesso!");
        } catch (error) {
            console.error("💥 Erro ao buscar dados da IA:", error);
            //   alert("Ocorreu um erro ao buscar dados da IA 😥");
        }
    });
});

export { }
