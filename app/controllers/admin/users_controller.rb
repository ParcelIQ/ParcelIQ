module Admin
  class UsersController < Admin::BaseController
    before_action :require_admin
    before_action :set_user, only: [ :show, :edit, :update, :destroy, :resend_invitation ]

    def index
      @users = User.all.order(created_at: :desc)
    end

    def show
    end

    def new
      @user = User.new
      @companies = Company.all.order(:name)
    end

    def create
      @user = User.new(user_params)

      # Custom validation for customer users requiring a company
      if @user.customer? && @user.company_id.blank?
        @user.errors.add(:company_id, "is required for customer users")
        @companies = Company.all.order(:name)
        return render :new, status: :unprocessable_entity
      end

      if @user.save
        # Send invitation email if user was saved successfully
        @user.invite!(current_user)
        redirect_to admin_user_path(@user), notice: "User was successfully created and invitation email sent."
      else
        @companies = Company.all.order(:name)
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @companies = Company.all.order(:name)
    end

    def update
      # Keep track of whether the email changed to potentially resend invitation
      email_changed = @user.email != user_params[:email]

      # Custom validation for customer users requiring a company
      if user_params[:role] == "customer" && user_params[:company_id].blank?
        @user.errors.add(:company_id, "is required for customer users")
        @companies = Company.all.order(:name)
        return render :edit, status: :unprocessable_entity
      end

      if @user.update(user_params)
        # If the email was changed, re-invite the user
        @user.invite! if email_changed
        redirect_to admin_user_path(@user), notice: "User was successfully updated."
      else
        @companies = Company.all.order(:name)
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @user == current_user
        redirect_to admin_users_path, alert: "You cannot delete your own account."
      else
        @user.destroy
        redirect_to admin_users_path, notice: "User was successfully deleted."
      end
    end

    def resend_invitation
      @user.invite!(current_user)
      redirect_to admin_user_path(@user), notice: "Invitation was successfully resent."
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :email,
        :name,
        :role,
        :company_id
      )
    end
  end
end
