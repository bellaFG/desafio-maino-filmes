# db/seeds.rb
require "logger"

ActiveRecord::Base.logger = Logger.new(STDOUT)

puts "🌱 Iniciando o seed do banco..."

# ======================
# 0️⃣ Usuário existente
# ======================
user = User.find_or_create_by!(email: "isabella.ferzales@gmail.com") do |u|
  u.name = "Isabella"
  u.password = "12345678"
  u.password_confirmation = "12345678"
end

# ======================
# 1️⃣ Categorias
# ======================
category_names = [
  "Ação", "Drama", "Terror", "Suspense",
  "Ficção Científica", "Fantasia", "Aventura", "Crime"
]

categories = category_names.map do |name|
  Category.find_or_create_by!(name: name)
end

def cat(*names)
  Category.where(name: names)
end

# ======================
# 2️⃣ Tags
# ======================
tag_names = [
  "Cult", "Oscar", "Clássico", "Baseado em Livro",
  "Psicológico", "Épico", "Ficção", "Mind-bending"
]

tags = tag_names.map do |name|
  Tag.find_or_create_by!(name: name)
end

def tag(*names)
  Tag.where(name: names)
end

# ======================
# 3️⃣ Dados dos filmes
# ======================
movies_data = [
  {
    title: "Pulp Fiction: Tempo de Violência",
    director: "Quentin Tarantino",
    year: 1994,
    duration: 154,
    synopsis: "Vidas de criminosos de Los Angeles se entrelaçam em histórias de violência, humor negro e coincidências inesperadas.",
    categories: cat("Crime", "Drama"),
    tags: tag("Cult", "Clássico")
  },
  {
    title: "O Iluminado",
    director: "Stanley Kubrick",
    year: 1980,
    duration: 146,
    synopsis: "Um homem aceita o cargo de zelador de um hotel isolado, mas forças sobrenaturais o levam à loucura.",
    categories: cat("Terror", "Suspense"),
    tags: tag("Clássico", "Psicológico", "Baseado em Livro")
  },
  {
    title: "O Labirinto do Fauno",
    director: "Guillermo del Toro",
    year: 2006,
    duration: 118,
    synopsis: "Durante a guerra civil espanhola, uma menina descobre um mundo sombrio de fantasia e mistério.",
    categories: cat("Fantasia", "Drama", "Aventura"),
    tags: tag("Oscar", "Ficção")
  },
  {
    title: "Gladiador",
    director: "Ridley Scott",
    year: 2000,
    duration: 155,
    synopsis: "Um general romano é traído e busca vingança como gladiador.",
    categories: cat("Ação", "Drama"),
    tags: tag("Oscar", "Épico")
  },
  {
    title: "Harry Potter e a Pedra Filosofal",
    director: "Chris Columbus",
    year: 2001,
    duration: 152,
    synopsis: "Um jovem descobre ser um bruxo e vai estudar na escola de magia Hogwarts.",
    categories: cat("Fantasia", "Aventura"),
    tags: tag("Baseado em Livro", "Cult", "Ficção")
  },
  {
    title: "A Origem",
    director: "Christopher Nolan",
    year: 2010,
    duration: 148,
    synopsis: "Um ladrão invade sonhos para roubar segredos e implantar ideias na mente das pessoas.",
    categories: cat("Ficção Científica", "Suspense", "Ação"),
    tags: tag("Mind-bending", "Oscar", "Ficção")
  }
]

# ======================
# 4️⃣ Criação e associação
# ======================
movies_data.each do |data|
  begin
    movie = Movie.find_or_initialize_by(title: data[:title])
    movie.assign_attributes(
      director: data[:director],
      year: data[:year],
      duration: data[:duration],
      synopsis: data[:synopsis],
      user: user  # <-- aqui associamos o usuário
    )
    movie.save!

    # Associações
    movie.categories = data[:categories]
    movie.tags = data[:tags]

    puts "🎬 #{movie.title} salvo com sucesso (#{movie.categories.count} categorias, #{movie.tags.count} tags)."
  rescue ActiveRecord::RecordInvalid => e
    puts "❌ Erro ao salvar '#{data[:title]}': #{e.record.errors.full_messages.join(', ')}"
  rescue => e
    puts "⚠️ Erro inesperado com '#{data[:title]}': #{e.message}"
  end
end

puts "✅ Seed concluído com sucesso!"
