class Post < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  has_rich_text :content
  validates :title, presence: true
  validates :content, presence: true
  validates :user_id, presence: true

  scope :search, -> (search_param = nil){
    return if search_param.blank?
    joins("INNER JOIN action_text_rich_texts ON action_text_rich_texts.record_id = posts.id AND action_text_rich_texts.record_type = 'Post'") .where("action_text_rich_texts.body LIKE ? OR posts.title LIKE ? ", "%#{search_param}%", "%#{search_param}%")
  }
end
