class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #validates_presence_of :email, :password
  has_one :account, foreign_key: :owner_id, dependent: :destroy
  #belongs_to :accounts_users, optional: true

end
