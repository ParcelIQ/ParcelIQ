class UsersController < ApplicationController
  before_action :authenticate_user! # You'll need to implement authentication
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]
  layout "tenant"

  def index
    @users = User.all # Automatically scoped to current tenant
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # Generate a random password for the user
    generated_password = Devise.friendly_token.first(8)
    @user.password = generated_password
    @user.password_confirmation = generated_password

    if @user.save
      # Send an email with the initial password (should be implemented)
      # UserMailer.welcome_email(@user, generated_password).deliver_later

      redirect_to users_path, notice: "User was successfully created. An email with login instructions has been sent."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:user][:password].blank?
      # Remove password fields if they're blank to avoid validation errors
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to users_path, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "User was successfully deleted."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
