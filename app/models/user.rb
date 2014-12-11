# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :name, :email, :password, :password_confirmation, :remember_me,:login
  attr_accessor :login
  validates :name,
  :uniqueness => {
    :case_sensitive => false
  }

  has_many :sites
  has_many :posts
  has_many :entries
  def display
    name.present? ? name : email.sub(/(\@.{4})(.+)$/,'\1...')
  end
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
