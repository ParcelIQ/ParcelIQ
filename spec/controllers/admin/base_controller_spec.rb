require 'rails_helper'
require_relative 'test_controller'

RSpec.describe Admin::TestController, type: :controller do
  let(:admin) { create(:admin_user) }
  let(:customer) { create(:customer_user) }

  describe "authentication and authorization" do
    describe "when not logged in" do
      it "does not allow access" do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "when logged in as non-admin" do
      before do
        sign_in customer
      end

      it "does not allow access" do
        get :index
        expect(response).to have_http_status(:forbidden)
      end

      it "sets an alert flash message" do
        get :index
        expect(flash[:alert]).to be_present
      end
    end

    describe "when logged in as admin" do
      before do
        sign_in admin
      end

      it "allows access" do
        get :index
        expect(response).to be_successful
      end
    end
  end
end
