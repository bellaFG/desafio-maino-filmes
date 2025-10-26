require "csv"

class MovieImportWorker
  include Sidekiq::Worker

  def perform(import_id)
    import = Import.find(import_id)
    import.update(status: "processing")

    file_path = ActiveStorage::Blob.service.path_for(import.file.key)

    total = 0
    CSV.foreach(file_path, headers: true) do |row|
      movie = Movie.new(
        title: row["title"],
        director: row["director"],
        year: row["year"],
        duration: row["duration"],
        synopsis: row["synopsis"],
        user: import.user
      )

      if movie.save
        total += 1
      else
      end
    end

    import.update(status: "finished")
    ImportMailer.with(import: import).completed.deliver_later
  rescue => e
    import.update(status: "failed")
    ImportMailer.with(import: import, error: e.message).failed.deliver_later
  end
end
