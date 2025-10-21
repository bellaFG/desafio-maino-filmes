class CommentsController < ApplicationController
  before_action :set_movie
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_user!  # somente usuários logados podem comentar
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def create
    @comment = @movie.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @movie, notice: "Comentário adicionado com sucesso."
    else
      redirect_to @movie, alert: "Não foi possível adicionar o comentário."
    end
  end

  def edit
    # rendera view edit.html.erb
  end

  def update
    if @comment.update(comment_params)
      redirect_to @movie, notice: "Comentário atualizado com sucesso."
    else
      render :edit, alert: "Não foi possível atualizar o comentário."
    end
  end

  def destroy
    @comment.destroy
    redirect_to @movie, notice: "Comentário removido."
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def set_comment
    @comment = @movie.comments.find(params[:id])
  end

  def authorize_user!
    redirect_to @movie, alert: "Você não pode alterar este comentário." unless @comment.user == current_user
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
