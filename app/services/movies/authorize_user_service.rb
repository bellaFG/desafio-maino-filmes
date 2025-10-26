# Service para autorização de usuário em ações de filme
module Movies
  class AuthorizeUserService
    def self.call(movie, user)
      movie.user == user
    end
  end
end
