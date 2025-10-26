class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def create
    name = params[:category][:name].strip
    normalized_name = I18n.transliterate(name).downcase

    # Busca ignorando caixa e acentos
    category = Category.all.find { |c| I18n.transliterate(c.name).downcase == normalized_name }
    if category
      render json: { id: category.id, name: category.name }
    else
      category = Category.new(name: name)
      if category.save
        render json: { id: category.id, name: category.name }
      else
        render json: { error: category.errors.full_messages.join(", ") }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    category = Category.find_by(id: params[:id])
    if category
      category.destroy
      render json: { success: true }
    else
      render json: { error: "Categoria não encontrada." }, status: :not_found
    end
  end
end
