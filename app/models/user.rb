class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :auth_token, uniqueness: true

  before_create :set_auth_token

  def set_auth_token
    self.auth_token = generate_auth_token
  end

  def generate_auth_token
    loop do
      token = Devise.friendly_token
      break token unless self.class.exists?(auth_token: token)
    end
  end

  def delete_auth_token
    self.auth_token = nil
    save
  end
end
