class Movie < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags
  has_one_attached :poster

  validates :title, :year, :director, presence: true

  scope :by_title, ->(title) { where("title ILIKE ?", "%#{title}%") if title.present? }
  scope :by_year, ->(year) { where(year: year) if year.present? }
  scope :by_director, ->(director) { where("director ILIKE ?", "%#{director}%") if director.present? }
end
