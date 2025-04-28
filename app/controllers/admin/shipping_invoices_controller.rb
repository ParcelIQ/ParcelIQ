module Admin
  class ShippingInvoicesController < Admin::BaseController
    before_action :set_shipping_invoice, only: [ :show, :edit, :update, :destroy ]
    before_action :set_companies, only: [ :new, :create, :edit, :update ]

    def index
      @shipping_invoices = ShippingInvoice.includes(:company).ordered
                                         .page(params[:page]).per(10)
    end

    def show
    end

    def new
      @shipping_invoice = ShippingInvoice.new
      @shipping_invoice.invoice_uploaded_date = Date.today
    end

    def edit
    end

    def create
      @shipping_invoice = ShippingInvoice.new(shipping_invoice_params)

      if @shipping_invoice.save
        redirect_to admin_shipping_invoice_path(@shipping_invoice), notice: "Shipping invoice was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @shipping_invoice.update(shipping_invoice_params)
        redirect_to admin_shipping_invoice_path(@shipping_invoice), notice: "Shipping invoice was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @shipping_invoice.destroy
      redirect_to admin_shipping_invoices_path, notice: "Shipping invoice was successfully destroyed."
    end

    private

    def set_shipping_invoice
      @shipping_invoice = ShippingInvoice.find(params[:id])
    end

    def set_companies
      @companies = Company.where(active: true).order(:name)
    end

    def shipping_invoice_params
      params.require(:shipping_invoice).permit(
        :name,
        :company_id,
        :carrier,
        :invoice_uploaded_date,
        :csv_file
      )
    end
  end
end
