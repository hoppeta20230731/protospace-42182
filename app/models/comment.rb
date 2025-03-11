class Comment < ApplicationRecord
  ## モデルと紐付け
  belongs_to :user
  belongs_to :prototype
  ## バリデーション
  validates :content, presence: true
end
