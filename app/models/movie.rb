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
end
