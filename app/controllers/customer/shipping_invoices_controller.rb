module Customer
  class ShippingInvoicesController < Customer::BaseController
    before_action :set_shipping_invoice, only: [ :show, :edit, :update, :destroy ]

    def index
      @shipping_invoices = current_tenant.shipping_invoices.ordered
                                       .page(params[:page]).per(10)
    end

    def show
    end

    def new
      @shipping_invoice = current_tenant.shipping_invoices.new
      @shipping_invoice.invoice_uploaded_date = Date.today
    end

    def edit
    end

    def create
      @shipping_invoice = current_tenant.shipping_invoices.new(shipping_invoice_params)

      if @shipping_invoice.save
        redirect_to customer_shipping_invoice_path(@shipping_invoice), notice: "Shipping invoice was successfully uploaded."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @shipping_invoice.update(shipping_invoice_params)
        redirect_to customer_shipping_invoice_path(@shipping_invoice), notice: "Shipping invoice was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @shipping_invoice.destroy
      redirect_to customer_shipping_invoices_path, notice: "Shipping invoice was successfully deleted."
    end

    private

    def set_shipping_invoice
      @shipping_invoice = current_tenant.shipping_invoices.find(params[:id])
    end

    def shipping_invoice_params
      params.require(:shipping_invoice).permit(
        :name,
        :carrier,
        :invoice_uploaded_date,
        :csv_file
      )
    end
  end
end
