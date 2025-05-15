class FedexInternationalPriorityImportDiscountProjection < ApplicationRecord
  belongs_to :shipping_invoice, optional: true
  belongs_to :company
  has_one :fedex_discount_basic_international, dependent: :destroy
  has_one :fedex_envelope_zone_discount_international, dependent: :destroy
  has_one :fedex_pak_zone_discount_international, dependent: :destroy
  has_many :fedex_box_zone_discount_internationals, dependent: :destroy
  has_one :fedex_envelope_minimum_charge_international, dependent: :destroy
  has_one :fedex_pak_minimum_charge_international, dependent: :destroy
  has_one :fedex_box_minimum_charge_international, dependent: :destroy

  validates :name, presence: true

  # Scopes
  scope :by_company, ->(company_id) { where(company_id: company_id) }

  accepts_nested_attributes_for :fedex_discount_basic_international, allow_destroy: true
  accepts_nested_attributes_for :fedex_envelope_zone_discount_international, allow_destroy: true
  accepts_nested_attributes_for :fedex_pak_zone_discount_international, allow_destroy: true
  accepts_nested_attributes_for :fedex_box_zone_discount_internationals, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :fedex_envelope_minimum_charge_international, allow_destroy: true
  accepts_nested_attributes_for :fedex_pak_minimum_charge_international, allow_destroy: true
  accepts_nested_attributes_for :fedex_box_minimum_charge_international, allow_destroy: true

  before_validation :build_associated_records

  def build_associated_records
    build_fedex_discount_basic_international if fedex_discount_basic_international.nil?
    build_fedex_envelope_zone_discount_international if fedex_envelope_zone_discount_international.nil?
    build_fedex_pak_zone_discount_international if fedex_pak_zone_discount_international.nil?
    build_fedex_envelope_minimum_charge_international if fedex_envelope_minimum_charge_international.nil?
    build_fedex_pak_minimum_charge_international if fedex_pak_minimum_charge_international.nil?
    build_fedex_box_minimum_charge_international if fedex_box_minimum_charge_international.nil?
  end

  def duplicate
    new_projection = self.dup
    new_projection.name = "#{name} (Copy)"
    new_projection.company = company
    new_projection.save

    # Copy basic settings
    if fedex_discount_basic_international.present?
      new_projection.create_fedex_discount_basic_international(fedex_discount_basic_international.attributes.except("id", "fedex_international_priority_import_discount_projection_id", "created_at", "updated_at"))
    end

    # Copy envelope zone discounts
    if fedex_envelope_zone_discount_international.present?
      new_projection.create_fedex_envelope_zone_discount_international(fedex_envelope_zone_discount_international.attributes.except("id", "fedex_international_priority_import_discount_projection_id", "created_at", "updated_at"))
    end

    # Copy pak zone discounts
    if fedex_pak_zone_discount_international.present?
      new_projection.create_fedex_pak_zone_discount_international(fedex_pak_zone_discount_international.attributes.except("id", "fedex_international_priority_import_discount_projection_id", "created_at", "updated_at"))
    end

    # Copy box zone discounts
    fedex_box_zone_discount_internationals.each do |discount|
      new_projection.fedex_box_zone_discount_internationals.create(discount.attributes.except("id", "fedex_international_priority_import_discount_projection_id", "created_at", "updated_at"))
    end

    # Copy envelope minimum charges
    if fedex_envelope_minimum_charge_international.present?
      new_projection.create_fedex_envelope_minimum_charge_international(fedex_envelope_minimum_charge_international.attributes.except("id", "fedex_international_priority_import_discount_projection_id", "created_at", "updated_at"))
    end

    # Copy pak minimum charges
    if fedex_pak_minimum_charge_international.present?
      new_projection.create_fedex_pak_minimum_charge_international(fedex_pak_minimum_charge_international.attributes.except("id", "fedex_international_priority_import_discount_projection_id", "created_at", "updated_at"))
    end

    # Copy box minimum charges
    if fedex_box_minimum_charge_international.present?
      new_projection.create_fedex_box_minimum_charge_international(fedex_box_minimum_charge_international.attributes.except("id", "fedex_international_priority_import_discount_projection_id", "created_at", "updated_at"))
    end

    new_projection
  end
end
