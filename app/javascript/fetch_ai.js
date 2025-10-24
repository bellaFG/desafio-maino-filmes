document.addEventListener("turbo:load", () => {
    const fetchBtn = document.getElementById("fetch-ai-btn");
    if (!fetchBtn) return;

    fetchBtn.addEventListener("click", async () => {
        const titleInput = document.getElementById("movie_title");
        if (!titleInput || !titleInput.value.trim()) {
            alert("Digite um título antes de buscar!");
            return;
        }

        try {
            const response = await fetch(`/movies/fetch_movie_data?title=${encodeURIComponent(titleInput.value)}`);
            if (!response.ok) throw new Error("Erro ao buscar dados da IA");

            const data = await response.json();

            // Preenche os campos automaticamente
            document.getElementById("movie_synopsis").value = data.synopsis || "";
            document.getElementById("movie_year").value = data.year || "";
            document.getElementById("movie_duration").value = data.duration || "";
            document.getElementById("movie_director").value = data.director || "";
            document.getElementById("movie_categories").value = data.categories || "";
            document.getElementById("movie_tags").value = data.tags || "";
        } catch (error) {
            console.error(error);
            alert("Ocorreu um erro ao buscar dados da IA 😥");
        }
    });
});
