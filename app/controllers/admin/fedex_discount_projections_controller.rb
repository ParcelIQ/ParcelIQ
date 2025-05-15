class Admin::FedexDiscountProjectionsController < Admin::BaseController
  before_action :set_projection, only: [ :show, :edit, :update, :destroy, :duplicate ]
  before_action :set_shipping_invoices, only: [ :new, :edit, :create, :update ]

  def index
    # If viewing from a shipping invoice, filter projections
    if params[:shipping_invoice_id].present?
      @shipping_invoice = ShippingInvoice.find_by(id: params[:shipping_invoice_id])
      @projections = @shipping_invoice&.fedex_discount_projections&.where(company: current_company) || FedexDiscountProjection.none
    else
      @projections = FedexDiscountProjection.where(company: current_company)
    end
  end

  def show
  end

  def new
    @projection = FedexDiscountProjection.new
    @projection.company = current_company
    @projection.shipping_invoice_id = params[:shipping_invoice_id] if params[:shipping_invoice_id].present?

    # Set a default name based on the shipping invoice if it's provided
    if params[:shipping_invoice_id].present?
      @shipping_invoice = ShippingInvoice.find_by(id: params[:shipping_invoice_id])
      @projection.name = "#{@shipping_invoice.name} - Projection" if @shipping_invoice
    end

    @projection.build_fedex_discount_basic
    @projection.build_fedex_envelope_zone_discount
    @projection.fedex_pak_box_zone_discounts.build
    @projection.build_fedex_envelope_minimum_charge(envelope_min_charge: 34.71)
    @projection.build_fedex_pak_box_minimum_charge(pakbox_min_charge: 42.31)
  end

  def edit
    @projection.fedex_pak_box_zone_discounts.build if @projection.fedex_pak_box_zone_discounts.empty?
  end

  def create
    @projection = FedexDiscountProjection.new(projection_params)
    @projection.company = current_company

    respond_to do |format|
      if @projection.save
        format.html { redirect_to edit_admin_fedex_discount_projection_path(@projection), notice: "FedEx discount projection was successfully created." }
        format.json { render :show, status: :created, location: @projection }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @projection.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @projection.update(projection_params)
        format.html { redirect_to edit_admin_fedex_discount_projection_path(@projection), notice: "FedEx discount projection was successfully updated." }
        format.json { render :show, status: :ok, location: @projection }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @projection.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @projection.destroy
    respond_to do |format|
      format.html { redirect_to admin_fedex_discount_projections_path, notice: "FedEx discount projection was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def duplicate
    new_projection = @projection.duplicate

    respond_to do |format|
      format.html { redirect_to edit_admin_fedex_discount_projection_path(new_projection), notice: "FedEx discount projection was successfully duplicated." }
      format.json { render :show, status: :created, location: new_projection }
    end
  end

  private

  def set_projection
    @projection = current_company.fedex_discount_projections.find(params[:id])
  end

  def set_shipping_invoices
    @shipping_invoices = current_company.shipping_invoices.where(carrier: "FedEx").order(invoice_uploaded_date: :desc)
  end

  def projection_params
    params.require(:fedex_discount_projection).permit(
      :name,
      :shipping_invoice_id,
      fedex_discount_basic_attributes: [
        :id, :dim_divisor, :envelope_earned_discount, :pakbox_earned_discount
      ],
      fedex_envelope_zone_discount_attributes: [
        :id, :zone_2_discount, :zone_3_discount, :zone_4_discount, :zone_5_discount,
        :zone_6_discount, :zone_7_discount, :zone_8_discount, :zone_9_10_discount, :zone_13_16_discount
      ],
      fedex_pak_box_zone_discounts_attributes: [
        :id, :low_weight, :max_weight, :zone_2_discount, :zone_3_discount,
        :zone_4_discount, :zone_5_discount, :zone_6_discount, :zone_7_discount,
        :zone_8_discount, :zone_9_10_discount, :zone_13_16_discount, :_destroy
      ],
      fedex_envelope_minimum_charge_attributes: [
        :id, :envelope_min_charge,
        :zone_2_min_charge, :zone_3_min_charge, :zone_4_min_charge,
        :zone_5_min_charge, :zone_6_min_charge, :zone_7_min_charge,
        :zone_8_min_charge, :zone_9_10_min_charge, :zone_13_16_min_charge,
        :zone_2_percentage_reduction, :zone_3_percentage_reduction, :zone_4_percentage_reduction,
        :zone_5_percentage_reduction, :zone_6_percentage_reduction, :zone_7_percentage_reduction,
        :zone_8_percentage_reduction, :zone_9_10_percentage_reduction, :zone_13_16_percentage_reduction,
        :zone_2_dollar_reduction, :zone_3_dollar_reduction, :zone_4_dollar_reduction,
        :zone_5_dollar_reduction, :zone_6_dollar_reduction, :zone_7_dollar_reduction,
        :zone_8_dollar_reduction, :zone_9_10_dollar_reduction, :zone_13_16_dollar_reduction
      ],
      fedex_pak_box_minimum_charge_attributes: [
        :id, :pakbox_min_charge,
        :zone_2_percentage_reduction, :zone_3_percentage_reduction, :zone_4_percentage_reduction,
        :zone_5_percentage_reduction, :zone_6_percentage_reduction, :zone_7_percentage_reduction,
        :zone_8_percentage_reduction, :zone_9_10_percentage_reduction, :zone_13_16_percentage_reduction,
        :zone_2_dollar_reduction, :zone_3_dollar_reduction, :zone_4_dollar_reduction,
        :zone_5_dollar_reduction, :zone_6_dollar_reduction, :zone_7_dollar_reduction,
        :zone_8_dollar_reduction, :zone_9_10_dollar_reduction, :zone_13_16_dollar_reduction
      ]
    )
  end
end
