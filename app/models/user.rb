class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Multitenancy - only for customer users, not for root_admin
  acts_as_tenant :company, optional: true
  belongs_to :company, optional: true

  # Validations
  validates :email, presence: true
  validates :email, uniqueness: { scope: :company_id }, if: :customer?
  validates :email, uniqueness: true, if: :root_admin?
  validates :name, presence: true
  validates :company, presence: true, if: :customer?
  validates :role, presence: true, inclusion: { in: [ "root_admin", "customer" ] }

  # Scopes
  scope :customer_users, -> { where(role: "customer") }
  scope :root_admin_users, -> { where(role: "root_admin") }

  # Role helpers
  def root_admin?
    role == "root_admin"
  end

  def customer?
    role == "customer"
  end

  # For backward compatibility
  alias_method :admin?, :customer?

  # Make sure authentication works with tenant-scoped email uniqueness
  def self.find_for_authentication(warden_conditions)
    where(email: warden_conditions[:email]).first
  end

  # Skip tenant scoping for root_admin users
  def self.scoped_by_tenant?
    ActsAsTenant.current_tenant.present? && where(role: "customer")
  end
end
