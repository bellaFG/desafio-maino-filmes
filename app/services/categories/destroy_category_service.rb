# Service para remover categoria
module Categories
  class DestroyCategoryService
    def self.call(id)
      category = Category.find_by(id: id)
      if category
        category.destroy
        { success: true }
      else
        { error: "Categoria não encontrada." }
      end
    end
  end
end
