require "csv"

class MovieImportWorker
  include Sidekiq::Worker

  def perform(import_id)
    puts "🚀 [WORKER] Iniciando importação ID: #{import_id}"

    import = Import.find(import_id)
    import.update(status: "processing")
    puts "🔄 [WORKER] Status atualizado para PROCESSING"

    file_path = ActiveStorage::Blob.service.path_for(import.file.key)
    puts "📂 [WORKER] Caminho do arquivo: #{file_path}"

    total = 0
    CSV.foreach(file_path, headers: true) do |row|
      puts "🎬 [WORKER] Importando filme: #{row['title']}"
      movie = Movie.new(
        title: row["title"],
        director: row["director"],
        year: row["year"],
        duration: row["duration"],
        synopsis: row["synopsis"],
        user: import.user
      )

      if movie.save
        puts "✅ [WORKER] Filme salvo: #{movie.title}"
        total += 1
      else
        puts "❌ [WORKER] Erro ao salvar '#{row['title']}': #{movie.errors.full_messages.join(', ')}"
      end
    end

    import.update(status: "finished")
    puts "✅ [WORKER] Importação concluída com sucesso (#{total} filmes)."
    ImportMailer.with(import: import).completed.deliver_later
    puts "📧 [WORKER] E-mail de sucesso enviado."
  rescue => e
    import.update(status: "failed")
    puts "💥 [WORKER] Erro ao importar CSV: #{e.message}"
    puts e.backtrace.join("\n")
    ImportMailer.with(import: import, error: e.message).failed.deliver_later
    puts "📧 [WORKER] E-mail de erro enviado."
  end
end
