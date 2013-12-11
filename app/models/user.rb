class User < ActiveRecord::Base
  attr_accessible :email, :username, :password
  attr_reader :password

  validates :email, :username, :session_token, presence: true
  validates :password, length: { within: 6..64, allow_nil: true }
  validates :password_digest, presence: { message: "Password can't be blank" }
  validates :email, email: true
  validates :username, username: true

  before_validation :ensure_session_token

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
  end

  private

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

end
