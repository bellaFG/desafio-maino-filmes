class Import < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  validates :file, presence: true
  validates :status, presence: true

  enum :status, {
    pending: 'pending',
    processing: 'processing',
    finished: 'finished',
    failed: 'failed'
  }, default: 'pending'
end
