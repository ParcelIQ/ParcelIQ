class Admin::FedexInternationalPriorityImportDiscountProjectionsController < Admin::BaseController
  before_action :set_projection, only: [ :show, :edit, :update, :destroy, :duplicate ]
  before_action :set_shipping_invoices, only: [ :new, :edit, :create, :update ]

  def index
    # If viewing from a shipping invoice, filter projections
    if params[:shipping_invoice_id].present?
      @shipping_invoice = ShippingInvoice.find_by(id: params[:shipping_invoice_id])
      @projections = @shipping_invoice&.fedex_international_priority_import_discount_projections&.where(company: current_company) || FedexInternationalPriorityImportDiscountProjection.none
    else
      @projections = FedexInternationalPriorityImportDiscountProjection.where(company: current_company)
    end
  end

  def show
  end

  def new
    @projection = FedexInternationalPriorityImportDiscountProjection.new
    @projection.company = current_company
    @projection.shipping_invoice_id = params[:shipping_invoice_id] if params[:shipping_invoice_id].present?

    # Set a default name based on the shipping invoice if it's provided
    if params[:shipping_invoice_id].present?
      @shipping_invoice = ShippingInvoice.find_by(id: params[:shipping_invoice_id])
      @projection.name = "#{@shipping_invoice.name} - Projection" if @shipping_invoice
    end

    @projection.build_fedex_discount_basic_international
    @projection.build_fedex_envelope_zone_discount_international
    @projection.build_fedex_pak_zone_discount_international
    @projection.fedex_box_zone_discount_internationals.build
    @projection.build_fedex_envelope_minimum_charge_international(envelope_min_charge: 59.50)
    @projection.build_fedex_pak_minimum_charge_international(pak_min_charge: 99.25)
    @projection.build_fedex_box_minimum_charge_international(box_min_charge: 119.61)
  end

  def edit
    @projection.fedex_box_zone_discount_internationals.build if @projection.fedex_box_zone_discount_internationals.empty?
  end

  def create
    @projection = FedexInternationalPriorityImportDiscountProjection.new(projection_params)
    @projection.company = current_company

    respond_to do |format|
      if @projection.save
        format.html { redirect_to edit_admin_fedex_international_priority_import_discount_projection_path(@projection), notice: "FedEx International Priority Import discount projection was successfully created." }
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
        format.html { redirect_to edit_admin_fedex_international_priority_import_discount_projection_path(@projection), notice: "FedEx International Priority Import discount projection was successfully updated." }
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
      format.html { redirect_to admin_fedex_international_priority_import_discount_projections_path, notice: "FedEx International Priority Import discount projection was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def duplicate
    new_projection = @projection.duplicate

    respond_to do |format|
      format.html { redirect_to edit_admin_fedex_international_priority_import_discount_projection_path(new_projection), notice: "FedEx International Priority Import discount projection was successfully duplicated." }
      format.json { render :show, status: :created, location: new_projection }
    end
  end

  private

  def set_projection
    @projection = current_company.fedex_international_priority_import_discount_projections.find(params[:id])
  end

  def set_shipping_invoices
    @shipping_invoices = current_company.shipping_invoices.where(carrier: "FedEx").order(invoice_uploaded_date: :desc)
  end

  def projection_params
    params.require(:fedex_international_priority_import_discount_projection).permit(
      :name,
      :shipping_invoice_id,
      fedex_discount_basic_international_attributes: [
        :id, :dim_divisor, :envelope_earned_discount, :pakbox_earned_discount
      ],
      fedex_envelope_zone_discount_international_attributes: [
        :id, :zone_a_discount, :zone_b_discount, :zone_c_discount, :zone_d_discount,
        :zone_e_discount, :zone_f_discount, :zone_g_discount, :zone_h_discount,
        :zone_i_discount, :zone_j_discount, :zone_k_discount, :zone_l_discount,
        :zone_m_discount, :zone_n_discount, :zone_o_discount, :zone_p_discount
      ],
      fedex_pak_zone_discount_international_attributes: [
        :id, :zone_a_discount, :zone_b_discount, :zone_c_discount, :zone_d_discount,
        :zone_e_discount, :zone_f_discount, :zone_g_discount, :zone_h_discount,
        :zone_i_discount, :zone_j_discount, :zone_k_discount, :zone_l_discount,
        :zone_m_discount, :zone_n_discount, :zone_o_discount, :zone_p_discount
      ],
      fedex_box_zone_discount_internationals_attributes: [
        :id, :low_weight, :max_weight,
        :zone_a_discount, :zone_b_discount, :zone_c_discount, :zone_d_discount,
        :zone_e_discount, :zone_f_discount, :zone_g_discount, :zone_h_discount,
        :zone_i_discount, :zone_j_discount, :zone_k_discount, :zone_l_discount,
        :zone_m_discount, :zone_n_discount, :zone_o_discount, :zone_p_discount, :_destroy
      ],
      fedex_envelope_minimum_charge_international_attributes: [
        :id, :envelope_min_charge,
        :zone_a_min_charge, :zone_b_min_charge, :zone_c_min_charge, :zone_d_min_charge,
        :zone_e_min_charge, :zone_f_min_charge, :zone_g_min_charge, :zone_h_min_charge,
        :zone_i_min_charge, :zone_j_min_charge, :zone_k_min_charge, :zone_l_min_charge,
        :zone_m_min_charge, :zone_n_min_charge, :zone_o_min_charge, :zone_p_min_charge,
        :zone_a_percentage_reduction, :zone_b_percentage_reduction, :zone_c_percentage_reduction, :zone_d_percentage_reduction,
        :zone_e_percentage_reduction, :zone_f_percentage_reduction, :zone_g_percentage_reduction, :zone_h_percentage_reduction,
        :zone_i_percentage_reduction, :zone_j_percentage_reduction, :zone_k_percentage_reduction, :zone_l_percentage_reduction,
        :zone_m_percentage_reduction, :zone_n_percentage_reduction, :zone_o_percentage_reduction, :zone_p_percentage_reduction,
        :zone_a_dollar_reduction, :zone_b_dollar_reduction, :zone_c_dollar_reduction, :zone_d_dollar_reduction,
        :zone_e_dollar_reduction, :zone_f_dollar_reduction, :zone_g_dollar_reduction, :zone_h_dollar_reduction,
        :zone_i_dollar_reduction, :zone_j_dollar_reduction, :zone_k_dollar_reduction, :zone_l_dollar_reduction,
        :zone_m_dollar_reduction, :zone_n_dollar_reduction, :zone_o_dollar_reduction, :zone_p_dollar_reduction
      ],
      fedex_pak_minimum_charge_international_attributes: [
        :id, :pak_min_charge,
        :zone_a_percentage_reduction, :zone_b_percentage_reduction, :zone_c_percentage_reduction, :zone_d_percentage_reduction,
        :zone_e_percentage_reduction, :zone_f_percentage_reduction, :zone_g_percentage_reduction, :zone_h_percentage_reduction,
        :zone_i_percentage_reduction, :zone_j_percentage_reduction, :zone_k_percentage_reduction, :zone_l_percentage_reduction,
        :zone_m_percentage_reduction, :zone_n_percentage_reduction, :zone_o_percentage_reduction, :zone_p_percentage_reduction,
        :zone_a_dollar_reduction, :zone_b_dollar_reduction, :zone_c_dollar_reduction, :zone_d_dollar_reduction,
        :zone_e_dollar_reduction, :zone_f_dollar_reduction, :zone_g_dollar_reduction, :zone_h_dollar_reduction,
        :zone_i_dollar_reduction, :zone_j_dollar_reduction, :zone_k_dollar_reduction, :zone_l_dollar_reduction,
        :zone_m_dollar_reduction, :zone_n_dollar_reduction, :zone_o_dollar_reduction, :zone_p_dollar_reduction
      ],
      fedex_box_minimum_charge_international_attributes: [
        :id, :box_min_charge,
        :zone_a_percentage_reduction, :zone_b_percentage_reduction, :zone_c_percentage_reduction, :zone_d_percentage_reduction,
        :zone_e_percentage_reduction, :zone_f_percentage_reduction, :zone_g_percentage_reduction, :zone_h_percentage_reduction,
        :zone_i_percentage_reduction, :zone_j_percentage_reduction, :zone_k_percentage_reduction, :zone_l_percentage_reduction,
        :zone_m_percentage_reduction, :zone_n_percentage_reduction, :zone_o_percentage_reduction, :zone_p_percentage_reduction,
        :zone_a_dollar_reduction, :zone_b_dollar_reduction, :zone_c_dollar_reduction, :zone_d_dollar_reduction,
        :zone_e_dollar_reduction, :zone_f_dollar_reduction, :zone_g_dollar_reduction, :zone_h_dollar_reduction,
        :zone_i_dollar_reduction, :zone_j_dollar_reduction, :zone_k_dollar_reduction, :zone_l_dollar_reduction,
        :zone_m_dollar_reduction, :zone_n_dollar_reduction, :zone_o_dollar_reduction, :zone_p_dollar_reduction
      ]
    )
  end
end
