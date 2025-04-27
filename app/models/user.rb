class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # For skipping password validation during invitation
  attr_accessor :skip_password_validation

  # Multitenancy - only for customer users, not for admins
  acts_as_tenant :company, optional: true
  belongs_to :company, optional: true

  # Validations
  validates :email, presence: true
  validates :email, uniqueness: { scope: :company_id }, if: :customer?
  validates :email, uniqueness: true, if: :admin?
  validates :name, presence: true
  validates :company, presence: true, if: :customer?
  validates :role, presence: true, inclusion: { in: [ "admin", "customer" ] }

  # Scopes
  scope :customer_users, -> { where(role: "customer") }
  scope :admin_users, -> { where(role: "admin") }

  # Role helpers
  def admin?
    role == "admin"
  end

  def customer?
    role == "customer"
  end

  # For backward compatibility
  alias_method :root_admin?, :admin?

  # Make sure authentication works with tenant-scoped email uniqueness
  def self.find_for_authentication(warden_conditions)
    where(email: warden_conditions[:email]).first
  end

  # Skip tenant scoping for admin users
  def self.scoped_by_tenant?
    ActsAsTenant.current_tenant.present? && where(role: "customer")
  end

  # Override Devise method to skip password validation when needed
  def password_required?
    return false if skip_password_validation
    super
  end
end
