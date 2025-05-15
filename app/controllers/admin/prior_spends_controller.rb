class Admin::PriorSpendsController < Admin::BaseController
  before_action :set_prior_spend, only: [ :show, :edit, :update, :destroy ]
  before_action :set_companies, only: [ :new, :create, :edit, :update ]

  def index
    @prior_spends = PriorSpend.includes(:company).order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
  end

  def new
    @prior_spend = PriorSpend.new
    @company_id = params[:company_id]
  end

  def create
    @prior_spend = PriorSpend.new(prior_spend_params)

    if @prior_spend.save
      redirect_to admin_prior_spends_path, notice: "Prior spend was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @prior_spend.update(prior_spend_params)
      redirect_to admin_prior_spends_path, notice: "Prior spend was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @prior_spend.destroy
    redirect_to admin_prior_spends_path, notice: "Prior spend was successfully deleted."
  end

  private

  def set_prior_spend
    @prior_spend = PriorSpend.find(params[:id])
  end

  def set_companies
    @companies = Company.all.order(:name)
  end

  def prior_spend_params
    params.require(:prior_spend).permit(:company_id, :carrier, :spend_type, :service_type, :shipment_count, :spend_amount)
  end
end
