class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :password, confirmation: true
  validates_presence_of :password_confirmation
  
  validates :email, uniqueness: true
end
