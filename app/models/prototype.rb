class Prototype < ApplicationRecord
  ## モデルの紐付け
  belongs_to :user
  has_many :comment, dependent: :destroy
  ## Active Storageのテーブルで管理された画像ファイルのアソシエーション
  has_one_attached :image
  ## バリデーション
  validates :title, presence: true
  validates :catch_copy, presence: true
  validates :concept, presence: true
  validates :image, presence: true
end
