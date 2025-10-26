# Service para criar categoria sem duplicidade (case/acento-insensitive)
module Categories
  class CreateCategoryService
    def self.call(name)
      name = name.strip
      normalized_name = I18n.transliterate(name).downcase
      category = Category.all.find { |c| I18n.transliterate(c.name).downcase == normalized_name }
      if category
        { id: category.id, name: category.name }
      else
        category = Category.new(name: name)
        if category.save
          { id: category.id, name: category.name }
        else
          { error: category.errors.full_messages.join(", ") }
        end
      end
    end
  end
end
