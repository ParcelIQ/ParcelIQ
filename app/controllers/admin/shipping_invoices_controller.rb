module Admin
  class ShippingInvoicesController < Admin::BaseController
    before_action :set_shipping_invoice, only: [ :show, :edit, :update, :destroy, :reprocess ]
    before_action :set_companies, only: [ :new, :create, :edit, :update ]

    def index
      @shipping_invoices = ShippingInvoice.includes(:company).ordered
                                         .page(params[:page]).per(10)
    end

    def show
      case @shipping_invoice.carrier
      when "UPS"
        @ups_invoice_entries = @shipping_invoice.ups_invoice_entries
                                              .ordered

        # Apply filters if provided
        if params[:query].present?
          query = params[:query].to_s.strip
          @ups_invoice_entries = @ups_invoice_entries.where(
            "tracking_number ILIKE ? OR
             invoice_number ILIKE ? OR
             receiver_name ILIKE ? OR
             receiver_city ILIKE ? OR
             receiver_state ILIKE ?",
            "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%"
          )
        end

        # Apply sorting if provided
        if params[:sort].present? && params[:direction].present?
          sort_column = params[:sort].to_s
          sort_direction = params[:direction].to_s.downcase == "desc" ? "desc" : "asc"

          # Only allow sorting on specific columns
          if [ "invoice_date", "invoice_number", "tracking_number", "net_amount" ].include?(sort_column)
            @ups_invoice_entries = @ups_invoice_entries.order("#{sort_column} #{sort_direction}")
          end
        end

        @ups_invoice_entries = @ups_invoice_entries.page(params[:page]).per(20)
      when "FedEx"
        @fedex_invoice_entries = @shipping_invoice.fedex_invoice_entries
                                                .ordered

        # Apply filters if provided
        if params[:query].present?
          query = params[:query].to_s.strip
          @fedex_invoice_entries = @fedex_invoice_entries.where(
            "express_or_ground_tracking_id ILIKE ? OR
             invoice_number ILIKE ? OR
             recipient_name ILIKE ? OR
             recipient_city ILIKE ? OR
             recipient_state ILIKE ?",
            "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%"
          )
        end

        # Apply sorting if provided
        if params[:sort].present? && params[:direction].present?
          sort_column = params[:sort].to_s
          sort_direction = params[:direction].to_s.downcase == "desc" ? "desc" : "asc"

          # Only allow sorting on specific columns
          if [ "invoice_date", "invoice_number", "express_or_ground_tracking_id", "net_charge_amount" ].include?(sort_column)
            @fedex_invoice_entries = @fedex_invoice_entries.order("#{sort_column} #{sort_direction}")
          end
        end

        @fedex_invoice_entries = @fedex_invoice_entries.page(params[:page]).per(20)
      end
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

    def reprocess
      case @shipping_invoice.carrier
      when "UPS"
        # Clear existing entries
        @shipping_invoice.ups_invoice_entries.destroy_all
      when "FedEx"
        # Clear existing entries
        @shipping_invoice.fedex_invoice_entries.destroy_all
      end

      # Reset processing status
      @shipping_invoice.update(
        processing_completed: false,
        processing_started_at: nil,
        processing_completed_at: nil,
        processing_summary: nil
      )

      # Start the background job again
      @shipping_invoice.process_invoice_data

      redirect_to admin_shipping_invoice_path(@shipping_invoice), notice: "Invoice reprocessing has been initiated."
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
