class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  attr_accessor :login

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :name, presence: true, uniqueness: {case_sensitive: true}, format: {with: /\A[a-zA-Z0-9 _\.]*\z/}

  has_many :products

  def self.find_first_by_auth_conditions(warden_conditions)

    conditions = warden_conditions.dup

    if login = conditions.delete(:login)

      where(conditions.to_hash).where("lower(name) = :value OR lower(email) = :value", value: login.downcase).first

    else

      where(conditions.to_hash).first

    end

  end

end
