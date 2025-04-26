class User < ApplicationRecord
  acts_as_tenant :company
  belongs_to :company

  validates :email, presence: true, uniqueness: { scope: :company_id }
  validates :name, presence: true
end
