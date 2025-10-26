class Movie < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags
  has_one_attached :poster

  validates :title, :year, :director, presence: true

  # ----- BUSCA GERAL (único campo) -----
  scope :search, ->(query) {
    if query.present?
      where("title ILIKE :q OR director ILIKE :q OR CAST(year AS TEXT) ILIKE :q", q: "%#{query}%")
    end
  }

  # ----- FILTROS -----
  scope :by_category, ->(category) { joins(:categories).where(categories: { name: category }) if category.present? }

  # ----- REMOÇÃO DE POSTER -----
  attr_accessor :remove_poster  # cria o atributo temporário para o checkbox

  before_save :purge_poster, if: -> { remove_poster == "1" } # remove poster se checkbox marcado

  private

  def purge_poster
    poster.purge_later
  end
end
