class CommentsController < ApplicationController
  before_action :set_movie
  before_action :authenticate_user!  # somente usuários logados podem comentar

  def create
    @comment = @movie.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @movie, notice: "Comentário adicionado com sucesso."
    else
      redirect_to @movie, alert: "Não foi possível adicionar o comentário."
    end
  end

  def destroy
    @comment = @movie.comments.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to @movie, notice: "Comentário removido."
    else
      redirect_to @movie, alert: "Você não pode excluir este comentário."
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
