class Post < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  has_rich_text :content
  validates :title, presence: true
  validates :content, presence: true
  validates :user_id, presence: true
end