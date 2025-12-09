class Mission < ApplicationRecord
  belongs_to :user

  VALID_CATEGORIES = %w[work personal shopping health other].freeze

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :priority, numericality: { only_integer: true, in: 0..3 }
  validates :category, inclusion: { in: VALID_CATEGORIES, message: "must be one of: #{VALID_CATEGORIES.join(', ')}" }, allow_blank: true
  validate :due_date_cannot_be_in_past, if: -> { due_date.present? && due_date_changed? }

  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :by_priority, -> { order(priority: :desc) }
  scope :by_due_date, -> { order(due_date: :asc) }

  private

  def due_date_cannot_be_in_past
    if due_date < Time.current.beginning_of_day
      errors.add(:due_date, "cannot be in the past")
    end
  end
end
