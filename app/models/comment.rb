class Comment < ApplicationRecord
  belongs_to :movie
  belongs_to :user, optional: true 

  validates :content, presence: true
  validates :name, presence: true, if: -> { user.nil? }
  validate :user_or_name_present

  private

  def user_or_name_present
    if user.blank? && name.blank?
      errors.add(:base, "Either user or name must be present")
    end
  end
end
