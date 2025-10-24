class CommentsController < ApplicationController
  before_action :set_movie
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def create
    @comment = @movie.comments.build(comment_params)
    @comment.user = current_user if user_signed_in?

    if @comment.save
      redirect_to @movie, notice: "Comentário adicionado com sucesso."
    else
      redirect_to @movie, alert: "Não foi possível adicionar o comentário."
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to @movie, notice: "Comentário atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
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
    # Só bloqueia edição/exclusão se o comentário tiver dono E o dono for outro usuário
    if @comment.user.present? && @comment.user != current_user
      redirect_to @movie, alert: "Você não pode alterar este comentário."
    end
  end

  def comment_params
    # Permite nome e conteúdo mesmo se não tiver usuário associado
    params.require(:comment).permit(:content, :name)
  end
end
