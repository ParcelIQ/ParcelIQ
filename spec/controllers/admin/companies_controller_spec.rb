require 'rails_helper'

RSpec.describe Admin::CompaniesController, type: :controller do
  let(:admin) { create(:admin_user) }
  let(:company_admin) { create(:admin_user) }
  let(:company) { create(:company) }
  let(:valid_attributes) { attributes_for(:company) }
  let(:invalid_attributes) { { name: '', subdomain: '', email: 'invalid' } }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns all companies as @companies" do
      get :index
      expect(assigns(:companies)).to include(company)
    end

    context "when logged in as non-admin" do
      before { sign_in company_admin }

      it "redirects to root path" do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: company.id }
      expect(response).to be_successful
    end

    it "assigns the requested company as @company" do
      get :show, params: { id: company.id }
      expect(assigns(:company)).to eq(company)
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end

    it "assigns a new company as @company" do
      get :new
      expect(assigns(:company)).to be_a_new(Company)
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: company.id }
      expect(response).to be_successful
    end

    it "assigns the requested company as @company" do
      get :edit, params: { id: company.id }
      expect(assigns(:company)).to eq(company)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Company" do
        expect {
          post :create, params: { company: valid_attributes }
        }.to change(Company, :count).by(1)
      end

      it "assigns a newly created company as @company" do
        post :create, params: { company: valid_attributes }
        expect(assigns(:company)).to be_a(Company)
        expect(assigns(:company)).to be_persisted
      end

      it "redirects to the created company" do
        post :create, params: { company: valid_attributes }
        expect(response).to redirect_to([ :admin, Company.last ])
      end

      it "sets a success flash message" do
        post :create, params: { company: valid_attributes }
        expect(flash[:notice]).to eq("Company was successfully created.")
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved company as @company" do
        post :create, params: { company: invalid_attributes }
        expect(assigns(:company)).to be_a_new(Company)
      end

      it "re-renders the 'new' template" do
        post :create, params: { company: invalid_attributes }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { name: "Updated Company Name" } }

      it "updates the requested company" do
        put :update, params: { id: company.id, company: new_attributes }
        company.reload
        expect(company.name).to eq("Updated Company Name")
      end

      it "assigns the requested company as @company" do
        put :update, params: { id: company.id, company: valid_attributes }
        expect(assigns(:company)).to eq(company)
      end

      it "redirects to the company" do
        put :update, params: { id: company.id, company: valid_attributes }
        expect(response).to redirect_to([ :admin, company ])
      end

      it "sets a success flash message" do
        put :update, params: { id: company.id, company: valid_attributes }
        expect(flash[:notice]).to eq("Company was successfully updated.")
      end
    end

    context "with invalid params" do
      it "assigns the company as @company" do
        put :update, params: { id: company.id, company: invalid_attributes }
        expect(assigns(:company)).to eq(company)
      end

      it "re-renders the 'edit' template" do
        put :update, params: { id: company.id, company: invalid_attributes }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    context "when company has no users" do
      it "destroys the requested company" do
        company_to_delete = create(:company)
        expect {
          delete :destroy, params: { id: company_to_delete.id }
        }.to change(Company, :count).by(-1)
      end

      it "redirects to the companies list" do
        delete :destroy, params: { id: company.id }
        expect(response).to redirect_to(admin_companies_path)
      end

      it "sets a success flash message" do
        delete :destroy, params: { id: company.id }
        expect(flash[:notice]).to eq("Company was successfully deleted.")
      end
    end

    context "when company has users" do
      before do
        create(:user, company: company)
      end

      it "does not destroy the company" do
        expect {
          delete :destroy, params: { id: company.id }
        }.not_to change(Company, :count)
      end

      it "redirects to the companies list" do
        delete :destroy, params: { id: company.id }
        expect(response).to redirect_to(admin_companies_path)
      end

      it "sets an alert flash message" do
        delete :destroy, params: { id: company.id }
        expect(flash[:alert]).to eq("Cannot delete company because it has users.")
      end
    end
  end

  describe "PUT #toggle_active" do
    it "toggles the active status of a company" do
      original_status = company.active
      put :toggle_active, params: { id: company.id }
      company.reload
      expect(company.active).to eq(!original_status)
    end

    it "redirects to the companies list" do
      put :toggle_active, params: { id: company.id }
      expect(response).to redirect_to(admin_companies_path)
    end

    it "sets a success flash message" do
      put :toggle_active, params: { id: company.id }
      new_status = company.reload.active ? "activated" : "deactivated"
      expect(flash[:notice]).to eq("Company was successfully #{new_status}.")
    end
  end
end
