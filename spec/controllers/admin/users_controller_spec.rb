require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin) { create(:admin_user) }
  let(:company_admin) { create(:admin_user) }
  let(:user) { create(:customer_user) }
  let(:company) { create(:company) }
  let(:valid_attributes) {
    {
      email: 'newuser@example.com',
      name: 'New User',
      role: 'customer',
      company_id: company.id
    }
  }
  let(:invalid_attributes) {
    {
      email: 'invalid-email',
      name: '',
      role: 'invalid-role'
    }
  }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns all users as @users" do
      get :index
      expect(assigns(:users)).to include(user)
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
      get :show, params: { id: user.id }
      expect(response).to be_successful
    end

    it "assigns the requested user as @user" do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end

    it "assigns a new user as @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it "assigns all companies as @companies" do
      get :new
      expect(assigns(:companies)).to include(company)
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: user.id }
      expect(response).to be_successful
    end

    it "assigns the requested user as @user" do
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it "assigns all companies as @companies" do
      get :edit, params: { id: user.id }
      expect(assigns(:companies)).to include(company)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new User" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :create, params: { user: valid_attributes }
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it "redirects to the created user" do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to([ :admin, User.last ])
      end

      it "sends an invitation email" do
        expect_any_instance_of(User).to receive(:invite!)
        post :create, params: { user: valid_attributes }
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        post :create, params: { user: invalid_attributes }
        expect(assigns(:user)).to be_a_new(User)
      end

      it "re-renders the 'new' template" do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template("new")
      end

      it "assigns all companies as @companies" do
        post :create, params: { user: invalid_attributes }
        expect(assigns(:companies)).to include(company)
      end
    end

    context "with customer role but no company" do
      let(:invalid_customer_params) {
        {
          email: 'newuser@example.com',
          name: 'New User',
          role: 'customer',
          company_id: ''
        }
      }

      it "does not create a new User" do
        expect {
          post :create, params: { user: invalid_customer_params }
        }.not_to change(User, :count)
      end

      it "adds an error about company being required" do
        post :create, params: { user: invalid_customer_params }
        expect(assigns(:user).errors[:company_id]).to include("is required for customer users")
      end

      it "re-renders the 'new' template" do
        post :create, params: { user: invalid_customer_params }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          name: "Updated Name",
          email: "updated@example.com"
        }
      }

      it "updates the requested user" do
        put :update, params: { id: user.id, user: new_attributes }
        user.reload
        expect(user.name).to eq("Updated Name")
        expect(user.email).to eq("updated@example.com")
      end

      it "assigns the requested user as @user" do
        put :update, params: { id: user.id, user: valid_attributes }
        expect(assigns(:user)).to eq(user)
      end

      it "redirects to the user" do
        put :update, params: { id: user.id, user: valid_attributes }
        expect(response).to redirect_to([ :admin, user ])
      end

      it "re-invites the user if email changed" do
        expect_any_instance_of(User).to receive(:invite!)
        put :update, params: { id: user.id, user: new_attributes }
      end
    end

    context "with invalid params" do
      it "assigns the user as @user" do
        put :update, params: { id: user.id, user: invalid_attributes }
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        put :update, params: { id: user.id, user: invalid_attributes }
        expect(response).to render_template("edit")
      end

      it "assigns all companies as @companies" do
        put :update, params: { id: user.id, user: invalid_attributes }
        expect(assigns(:companies)).to include(company)
      end
    end

    context "changing to customer role but no company" do
      let(:invalid_customer_params) {
        {
          role: 'customer',
          company_id: ''
        }
      }

      it "does not update the user" do
        original_role = user.role
        put :update, params: { id: user.id, user: invalid_customer_params }
        user.reload
        expect(user.role).to eq(original_role)
      end

      it "adds an error about company being required" do
        put :update, params: { id: user.id, user: invalid_customer_params }
        expect(assigns(:user).errors[:company_id]).to include("is required for customer users")
      end

      it "re-renders the 'edit' template" do
        put :update, params: { id: user.id, user: invalid_customer_params }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    context "when deleting another user" do
      it "destroys the requested user" do
        user_to_delete = create(:user)
        expect {
          delete :destroy, params: { id: user_to_delete.id }
        }.to change(User, :count).by(-1)
      end

      it "redirects to the users list" do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to(admin_users_path)
      end

      it "sets a notice flash message" do
        delete :destroy, params: { id: user.id }
        expect(flash[:notice]).to eq("User was successfully deleted.")
      end
    end

    context "when trying to delete own account" do
      it "does not destroy the user" do
        expect {
          delete :destroy, params: { id: admin.id }
        }.not_to change(User, :count)
      end

      it "redirects to the users list" do
        delete :destroy, params: { id: admin.id }
        expect(response).to redirect_to(admin_users_path)
      end

      it "sets an alert flash message" do
        delete :destroy, params: { id: admin.id }
        expect(flash[:alert]).to eq("You cannot delete your own account.")
      end
    end
  end

  describe "POST #resend_invitation" do
    it "resends the invitation to the user" do
      expect_any_instance_of(User).to receive(:invite!)
      post :resend_invitation, params: { id: user.id }
    end

    it "redirects to the user" do
      post :resend_invitation, params: { id: user.id }
      expect(response).to redirect_to([ :admin, user ])
    end

    it "sets a notice flash message" do
      post :resend_invitation, params: { id: user.id }
      expect(flash[:notice]).to eq("Invitation was successfully resent.")
    end
  end
end
