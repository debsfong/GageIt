# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  validates :username, :password_digest, :session_token, presence: true
  validates :username, :session_token, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true
  attr_reader :password
  after_initialize :ensure_session_token

  has_many :subs,
    class_name: :Sub,
    primary_key: :id,
    foreign_key: :moderator_id,
    dependent: :destroy

  has_many :posts,
    class_name: :Post,
    primary_key: :id,
    foreign_key: :author_id,
    dependent: :destroy

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil unless user
    user.is_password?(password) ? user : nil
  end

  def password=(password)
    @password = password
    password_digest = BCrypt::Password.create(password)
    self.password_digest = password_digest
  end

  def is_password?(password)
    bc_obj = BCrypt::Password.new(self.password_digest)
    bc_obj.is_password?(password)
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
  end
end
