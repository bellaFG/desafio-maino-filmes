class Import < ApplicationRecord
  belongs_to :user, optional: true

  enum status: {
    pending: 0,
    processing: 1,
    finished: 2,
    failed: 3
  }

  has_one_attached :file
end
