class MovieImportWorker
  include Sidekiq::Worker

  def perform(import_id)
    import = Import.find(import_id)
    import.update(status: "processing")

    file_path = ActiveStorage::Blob.service.send(:path_for, import.file.key)

    CSV.foreach(file_path, headers: true) do |row|
      Movie.create!(
        title: row["title"],
        director: row["director"],
        year: row["year"],
        duration: row["duration"],
        synopsis: row["synopsis"]
      )
    end

    import.update(status: "finished")
    ImportMailer.with(import: import).completed.deliver_later
  rescue => e
    import.update(status: "failed")
    ImportMailer.with(import: import, error: e.message).failed.deliver_later
  end
end
