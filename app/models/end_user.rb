class EndUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :juicer_ingredients, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_smoothies, through: :favorites, source: :smoothie
  # エンドユーザーからfavoriteしたsmoothie一覧を持ってくる時に必要な記述
  has_many :smoothies, class_name: 'Smoothie', dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :in_juicer_ingredients, through: :juicer_ingredients, source: :ingredient

  def active_for_authentication?
    super && (self.is_deleted == false)
  end
end