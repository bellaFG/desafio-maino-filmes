class Import < ApplicationRecord
  belongs_to :user, optional: true
  has_one_attached :file

  enum :status, { pending: "pending", processing: "processing", finished: "finished", failed: "failed" }

  validates :file, presence: true

  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= :pending
  end
end
