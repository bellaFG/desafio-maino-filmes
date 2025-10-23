class Comment < ApplicationRecord
  belongs_to :movie
  belongs_to :user, optional: true 

  validates :content, presence: true
  validates :name, presence: true, if: -> { user.nil? }  
end
