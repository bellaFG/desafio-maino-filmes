class Import < ApplicationRecord
  belongs_to :user, optional: true
  enum status: { pending: "pending", processing: "processing", finished: "finished", failed: "failed" }
  has_one_attached :file
end
