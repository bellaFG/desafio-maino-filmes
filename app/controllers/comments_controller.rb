class CommentsController < ApplicationController
  before_action :set_movie
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def create
    @comment = @movie.comments.build(comment_params)
    @comment.user = current_user if user_signed_in?

    if @comment.save
      redirect_to @movie, notice: t('comments.create.success', default: "Comentário adicionado com sucesso.")
    else
      redirect_to @movie, alert: t('comments.create.failure', default: "Não foi possível adicionar o comentário.")
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to @movie, notice: t('comments.update.success', default: "Comentário atualizado com sucesso.")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to @movie, notice: t('comments.destroy.success', default: "Comentário removido.")
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def set_comment
    @comment = @movie.comments.find(params[:id])
  end

  def authorize_user!
    return unless @comment.user.present? && @comment.user != current_user

    redirect_to @movie, alert: t('comments.unauthorized', default: "Você não pode alterar este comentário.")
  end

  def comment_params
    params.require(:comment).permit(:content, :name)
  end
end
