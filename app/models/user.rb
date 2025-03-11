class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  ## モデルの紐付け
  has_many :prototypes
  has_many :comment
  ## バリデーション設定（空欄NG & 最大文字数設定）
  validates :name, presence: true, length: { maximum: 50 }
  validates :profile, presence: true, length: { maximum: 500 }
  validates :occupation, presence: true, length: { maximum: 100 }
  validates :position, presence: true, length: { maximum: 100 }
end
