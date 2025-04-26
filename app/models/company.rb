class Company < ApplicationRecord
  has_one_attached :logo
  has_many :users, dependent: :restrict_with_error

  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true,
    format: { with: /\A[a-z0-9]+(-[a-z0-9]+)*\z/, message: "can only contain lowercase letters, numbers, and hyphens" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :website, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
  validates :time_zone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }, allow_blank: true

  # Default values
  attribute :active, :boolean, default: true
  attribute :settings, :jsonb, default: -> { {} }
  attribute :metadata, :jsonb, default: -> { {} }
  attribute :time_zone, :string, default: "UTC"

  # Callbacks
  before_validation :normalize_subdomain

  private

  def normalize_subdomain
    self.subdomain = subdomain.to_s.downcase.parameterize if subdomain.present?
  end
end
