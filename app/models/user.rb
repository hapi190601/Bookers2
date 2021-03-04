class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :relationships


  # フォローするユーザー
  has_many :active_relationships,
                      class_name: "Relationship",
                      foreign_key: "follower_id",
                      dependent: :destroy

  # 自分がフォローしているユーザー
  has_many :followings, through: :active_relationships, source: :followed


  # 自分がフォローされているユーザー
  has_many :passive_relationships,
                      class_name: "Relationship",
                      foreign_key: "followed_id",
                      dependent: :destroy

  # 自分をフォローしているユーザー
  has_many :followers, through: :passive_relationships, source: :follower

  # フォローする
  def follow(user_id)
    active_relationships.create(followed_id: user_id)
  end

  # フォローを外す
  def unfollow(user_id)
    active_relationships.find_by(followed_id: user_id).destroy
  end

  # すでにフォローしているのか確認
  def following?(user)
    followings.include?(user)
  end


  validates :name, uniqueness: true , length: {in: 2..20}
  validates :introduction, length: { maximum: 50 }


  attachment :profile_image
end
