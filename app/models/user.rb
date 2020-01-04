class User < ApplicationRecord
  has_many :games, ->(user) { unscope(where: :user_id).where("black_user_id = ? OR white_user_id = ?", user.id, user.id) }, class_name: 'Game'

  # OmniAuth Helper Function
  def self.from_omniauth(auth)
    email = auth.info.email
    user = User.find_by(email: email) if email
    user ||= User.create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.email ||= "#{auth.uid}_#{auth.uid}@email.com"
    end
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]
end
