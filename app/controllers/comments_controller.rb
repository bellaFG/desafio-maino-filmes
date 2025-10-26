class CommentsController < ApplicationController
  before_action :set_movie
  before_action :set_comment, only: [ :edit, :update, :destroy ]
  before_action :authenticate_user!, only: [ :edit, :update, :destroy ], if: :require_auth_for_comment?
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  def create
    @comment = @movie.comments.build(comment_params)
    if user_signed_in?
      @comment.user = current_user
    else
      # Gera identificador único para comentário anônimo
      anon_id = cookies.signed[:anon_comment_id] ||= SecureRandom.uuid
      @comment.name ||= "Anônimo"
      @comment.anon_session_id = anon_id if @comment.respond_to?(:anon_session_id=)
    end

    if @comment.save
      redirect_to @movie, notice: t("comments.create.success", default: "Comentário adicionado com sucesso.")
    else
      redirect_to @movie, alert: t("comments.create.failure", default: "Não foi possível adicionar o comentário.")
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to @movie, notice: t("comments.update.success", default: "Comentário atualizado com sucesso.")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to @movie, notice: t("comments.destroy.success", default: "Comentário removido.")
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def set_comment
    @comment = @movie.comments.find(params[:id])
  end

  # Só exige autenticação se o comentário for de usuário autenticado
  def require_auth_for_comment?
    @comment.user.present?
  end

  def authorize_user!
    if @comment.user.present?
      unless @comment.user == current_user
        redirect_to @movie, alert: t("comments.unauthorized", default: "Você não pode alterar ou excluir este comentário.")
      end
    else
      # Para comentário anônimo, só permite se o cookie bate com o identificador salvo
      anon_id = cookies.signed[:anon_comment_id]
      unless @comment.respond_to?(:anon_session_id) && @comment.anon_session_id.present? && anon_id == @comment.anon_session_id
        redirect_to @movie, alert: t("comments.unauthorized", default: "Você não pode alterar ou excluir este comentário.")
      end
    end
  end

  def comment_params
    params.require(:comment).permit(:content, :name)
  end
end
