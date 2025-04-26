require 'rails_helper'

RSpec.describe "Admin::Companies", type: :request do
  let(:admin) { create(:user, role: 'root_admin') }
  let(:company_admin) { create(:user, role: 'company_admin') }
  let(:company) { create(:company) }

  describe "as an admin user" do
    before do
      sign_in admin
    end

    describe "GET /admin/companies" do
      it "returns a successful response" do
        get admin_companies_path
        expect(response).to be_successful
      end
    end

    describe "GET /admin/companies/:id" do
      it "returns a successful response" do
        get admin_company_path(company)
        expect(response).to be_successful
      end
    end

    describe "GET /admin/companies/new" do
      it "returns a successful response" do
        get new_admin_company_path
        expect(response).to be_successful
      end
    end

    describe "GET /admin/companies/:id/edit" do
      it "returns a successful response" do
        get edit_admin_company_path(company)
        expect(response).to be_successful
      end
    end

    describe "POST /admin/companies" do
      context "with valid parameters" do
        let(:valid_params) { { company: attributes_for(:company) } }

        it "creates a new company" do
          expect {
            post admin_companies_path, params: valid_params
          }.to change(Company, :count).by(1)
        end

        it "redirects to the new company" do
          post admin_companies_path, params: valid_params
          expect(response).to redirect_to(admin_company_path(Company.last))
        end
      end

      context "with invalid parameters" do
        let(:invalid_params) { { company: { name: '', subdomain: '', email: 'invalid' } } }

        it "does not create a new company" do
          expect {
            post admin_companies_path, params: invalid_params
          }.not_to change(Company, :count)
        end

        it "returns unprocessable entity status" do
          post admin_companies_path, params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "PATCH /admin/companies/:id" do
      context "with valid parameters" do
        let(:new_attributes) { { company: { name: "Updated Name" } } }

        it "updates the company" do
          patch admin_company_path(company), params: new_attributes
          company.reload
          expect(company.name).to eq("Updated Name")
        end

        it "redirects to the company" do
          patch admin_company_path(company), params: new_attributes
          expect(response).to redirect_to(admin_company_path(company))
        end
      end

      context "with invalid parameters" do
        let(:invalid_params) { { company: { name: '', email: 'invalid' } } }

        it "does not update the company" do
          original_name = company.name
          patch admin_company_path(company), params: invalid_params
          company.reload
          expect(company.name).to eq(original_name)
        end

        it "returns unprocessable entity status" do
          patch admin_company_path(company), params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "DELETE /admin/companies/:id" do
      context "when company has no users" do
        it "destroys the company" do
          company_to_delete = create(:company)
          expect {
            delete admin_company_path(company_to_delete)
          }.to change(Company, :count).by(-1)
        end

        it "redirects to the companies index" do
          delete admin_company_path(company)
          expect(response).to redirect_to(admin_companies_path)
        end
      end

      context "when company has users" do
        before do
          create(:user, company: company)
        end

        it "does not destroy the company" do
          expect {
            delete admin_company_path(company)
          }.not_to change(Company, :count)
        end

        it "redirects to the companies index with an alert" do
          delete admin_company_path(company)
          expect(response).to redirect_to(admin_companies_path)
          follow_redirect!
          expect(response.body).to include("Cannot delete company because it has users")
        end
      end
    end

    describe "PUT /admin/companies/:id/toggle_active" do
      it "toggles the active status of the company" do
        original_status = company.active
        put toggle_active_admin_company_path(company)
        company.reload
        expect(company.active).to eq(!original_status)
      end

      it "redirects to the companies index" do
        put toggle_active_admin_company_path(company)
        expect(response).to redirect_to(admin_companies_path)
      end
    end
  end

  describe "as a non-admin user" do
    before do
      sign_in company_admin
    end

    describe "GET /admin/companies" do
      it "returns a forbidden response" do
        get admin_companies_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("You are not authorized to access this page")
      end
    end

    describe "POST /admin/companies" do
      it "does not create a company" do
        expect {
          post admin_companies_path, params: { company: attributes_for(:company) }
        }.not_to change(Company, :count)
      end

      it "returns a forbidden response" do
        post admin_companies_path, params: { company: attributes_for(:company) }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
