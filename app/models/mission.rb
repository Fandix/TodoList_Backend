class Mission < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :priority, numericality: { in: 0..3 }

  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :by_priority, -> { order(priority: :desc) }
  scope :by_due_date, -> { order(due_date: :asc) }
  scope :by_category, ->(category) { where(category: category) if category.present? }
end
