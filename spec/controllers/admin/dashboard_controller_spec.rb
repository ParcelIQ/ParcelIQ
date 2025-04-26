require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  let(:admin) { create(:admin_user) }
  let(:company_admin) { create(:admin_user) }
  let(:company) { create(:company) }

  before do
    create(:company)  # Create a company to ensure there are statistics to display
    create(:customer_user)     # Create a user to ensure there are statistics to display
  end

  describe "GET #index" do
    context "when logged in as admin" do
      before do
        sign_in admin
      end

      it "returns a success response" do
        get :index
        expect(response).to be_successful
      end

      it "assigns all companies to @companies" do
        get :index
        expect(assigns(:companies)).to be_present
        expect(assigns(:companies).count).to eq(Company.count)
      end

      it "assigns all users to @users" do
        get :index
        expect(assigns(:users)).to be_present
        expect(assigns(:users).count).to eq(User.count)
      end

      it "assigns total users count to @total_users" do
        get :index
        expect(assigns(:total_users)).to eq(User.count)
      end

      it "assigns total companies count to @total_companies" do
        get :index
        expect(assigns(:total_companies)).to eq(Company.count)
      end
    end

    context "when logged in as non-admin" do
      before do
        sign_in company_admin
      end

      it "redirects to root path" do
        get :index
        expect(response).to redirect_to(root_path)
      end

      it "sets an alert flash message" do
        get :index
        expect(flash[:alert]).to eq("You are not authorized to access this area.")
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
