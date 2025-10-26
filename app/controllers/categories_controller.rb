class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def create
    result = Categories::CreateCategoryService.call(params[:category][:name])
    if result[:error]
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      render json: { id: result[:id], name: result[:name] }
    end
  end

  def destroy
    result = Categories::DestroyCategoryService.call(params[:id])
    if result[:error]
      render json: { error: result[:error] }, status: :not_found
    else
      render json: { success: true }
    end
  end
end
