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
  # フォローする側のUserから見て(foreign_keyの設定)、フォローされる側のUserを(中間テーブルを介して)集める。
  has_many :active_relationships,
                      class_name: "Relationship",
                      foreign_key: "follower_id",
                      dependent: :destroy

  # 自分がフォローしているユーザー
  # 中間テーブルを介して「followed」モデルのUser(フォローされた側)を集めることを「followings」と定義
  has_many :followings, through: :active_relationships, source: :followed


  # フォローされているユーザー
  # フォローされる側のUserから見て(foreign_keyの設定)、フォローしてくる側のUserを(中間テーブルを介して)集める。
  has_many :passive_relationships,
                      class_name: "Relationship",
                      foreign_key: "followed_id",
                      dependent: :destroy

  # 自分がフォローされているユーザー
  # 中間テーブルを介して「follower」モデルのUser(フォローする側)を集めることを「followers」と定義
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

  # 検索機能
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE ?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

  validates :name, uniqueness: true , length: {in: 2..20}
  validates :introduction, length: { maximum: 50 }

  attachment :profile_image
end
