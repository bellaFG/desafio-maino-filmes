# Service para atribuir tags a um filme
module Movies
  class AssignTagsService
    def self.call(movie, tag_list)
      if tag_list.present?
        tag_names = tag_list.split(",").map(&:strip).uniq
        movie.tags = tag_names.map { |name| Tag.find_or_create_by(name: name) }
      else
        movie.tags.clear
      end
    end
  end
end
