class FedexPriorityOvernightDiscountProjection < ApplicationRecord
  belongs_to :shipping_invoice, optional: true
  belongs_to :company
  has_one :fedex_discount_basic, dependent: :destroy
  has_one :fedex_envelope_zone_discount, dependent: :destroy
  has_many :fedex_pak_box_zone_discounts, dependent: :destroy
  has_one :fedex_envelope_minimum_charge, dependent: :destroy
  has_one :fedex_pak_box_minimum_charge, dependent: :destroy

  validates :name, presence: true

  # Scopes
  scope :by_company, ->(company_id) { where(company_id: company_id) }

  accepts_nested_attributes_for :fedex_discount_basic, allow_destroy: true
  accepts_nested_attributes_for :fedex_envelope_zone_discount, allow_destroy: true
  accepts_nested_attributes_for :fedex_pak_box_zone_discounts, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :fedex_envelope_minimum_charge, allow_destroy: true
  accepts_nested_attributes_for :fedex_pak_box_minimum_charge, allow_destroy: true

  after_create :create_associated_records

  def create_associated_records
    create_fedex_discount_basic if fedex_discount_basic.nil?
    create_fedex_envelope_zone_discount if fedex_envelope_zone_discount.nil?
    create_fedex_envelope_minimum_charge if fedex_envelope_minimum_charge.nil?
    create_fedex_pak_box_minimum_charge if fedex_pak_box_minimum_charge.nil?

    # Ensure at least one pak/box zone discount exists
    if fedex_pak_box_zone_discounts.empty?
      fedex_pak_box_zone_discounts.create(low_weight: 0, max_weight: 1)
    end
  end

  def duplicate
    new_projection = self.dup
    new_projection.name = "#{name} (Copy)"
    new_projection.company = company
    new_projection.save

    # Copy basic settings
    if fedex_discount_basic.present?
      new_projection.create_fedex_discount_basic(fedex_discount_basic.attributes.except("id", "fedex_priority_overnight_discount_projection_id", "created_at", "updated_at"))
    end

    # Copy envelope zone discounts
    if fedex_envelope_zone_discount.present?
      new_projection.create_fedex_envelope_zone_discount(fedex_envelope_zone_discount.attributes.except("id", "fedex_priority_overnight_discount_projection_id", "created_at", "updated_at"))
    end

    # Copy pak/box zone discounts
    fedex_pak_box_zone_discounts.each do |discount|
      new_projection.fedex_pak_box_zone_discounts.create(discount.attributes.except("id", "fedex_priority_overnight_discount_projection_id", "created_at", "updated_at"))
    end

    # Copy envelope minimum charges
    if fedex_envelope_minimum_charge.present?
      new_projection.create_fedex_envelope_minimum_charge(fedex_envelope_minimum_charge.attributes.except("id", "fedex_priority_overnight_discount_projection_id", "created_at", "updated_at"))
    end

    # Copy pak/box minimum charges
    if fedex_pak_box_minimum_charge.present?
      new_projection.create_fedex_pak_box_minimum_charge(fedex_pak_box_minimum_charge.attributes.except("id", "fedex_priority_overnight_discount_projection_id", "created_at", "updated_at"))
    end

    new_projection
  end
end
