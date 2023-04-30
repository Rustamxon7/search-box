class Article < ApplicationRecord
  belongs_to :user

  validates :title, :content, presence: true

  scope :search, -> (query) { where('lower(title) LIKE ?', "%#{query.downcase}%") }
end