class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true, length: { minimum: 3 }

  def self.authenticate_with_credentials(email, password)
    user = User.find_by("LOWER(email)= ?", email.strip.downcase).try(:authenticate, password)
    if user
      user
    else
      nil
    end
  end
end
