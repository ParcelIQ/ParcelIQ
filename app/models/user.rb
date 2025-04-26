class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Multitenancy
  acts_as_tenant :company
  belongs_to :company

  # Validations
  validates :email, presence: true, uniqueness: { scope: :company_id }
  validates :name, presence: true

  # Make sure authentication works with tenant-scoped email uniqueness
  def self.find_for_authentication(warden_conditions)
    where(email: warden_conditions[:email]).first
  end
end
