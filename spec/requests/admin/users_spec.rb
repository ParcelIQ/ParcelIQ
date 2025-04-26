require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let(:admin) { create(:admin_user) }
  let(:company_admin) { create(:admin_user) }
  let(:user) { create(:customer_user) }
  let(:company) { create(:company) }

  describe "as an admin user" do
    before do
      sign_in admin
    end

    describe "GET /admin/users" do
      it "returns a successful response" do
        get admin_users_path
        expect(response).to be_successful
      end
    end

    describe "GET /admin/users/:id" do
      it "returns a successful response" do
        get admin_user_path(user)
        expect(response).to be_successful
      end
    end

    describe "GET /admin/users/new" do
      it "returns a successful response" do
        get new_admin_user_path
        expect(response).to be_successful
      end
    end

    describe "GET /admin/users/:id/edit" do
      it "returns a successful response" do
        get edit_admin_user_path(user)
        expect(response).to be_successful
      end
    end

    describe "POST /admin/users" do
      context "with valid parameters" do
        let(:valid_params) {
          {
            user: {
              email: 'newuser@example.com',
              name: 'New User',
              role: 'customer',
              company_id: company.id
            }
          }
        }

        it "creates a new user" do
          expect {
            post admin_users_path, params: valid_params
          }.to change(User, :count).by(1)
        end

        it "redirects to the new user" do
          post admin_users_path, params: valid_params
          expect(response).to redirect_to(admin_user_path(User.last))
        end
      end

      context "with invalid parameters" do
        let(:invalid_params) {
          {
            user: {
              email: 'invalid-email',
              name: '',
              role: 'invalid-role'
            }
          }
        }

        it "does not create a new user" do
          expect {
            post admin_users_path, params: invalid_params
          }.not_to change(User, :count)
        end

        it "returns unprocessable entity status" do
          post admin_users_path, params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "PATCH /admin/users/:id" do
      context "with valid parameters" do
        let(:new_attributes) { { user: { name: "Updated Name" } } }

        it "updates the user" do
          patch admin_user_path(user), params: new_attributes
          user.reload
          expect(user.name).to eq("Updated Name")
        end

        it "redirects to the user" do
          patch admin_user_path(user), params: new_attributes
          expect(response).to redirect_to(admin_user_path(user))
        end
      end

      context "with invalid parameters" do
        let(:invalid_params) { { user: { email: 'invalid-email' } } }

        it "does not update the user" do
          original_email = user.email
          patch admin_user_path(user), params: invalid_params
          user.reload
          expect(user.email).to eq(original_email)
        end

        it "returns unprocessable entity status" do
          patch admin_user_path(user), params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "DELETE /admin/users/:id" do
      it "destroys the user" do
        user_to_delete = create(:user)
        expect {
          delete admin_user_path(user_to_delete)
        }.to change(User, :count).by(-1)
      end

      it "redirects to the users index" do
        delete admin_user_path(user)
        expect(response).to redirect_to(admin_users_path)
      end

      it "does not allow deleting own account" do
        expect {
          delete admin_user_path(admin)
        }.not_to change(User, :count)
        expect(response).to redirect_to(admin_users_path)
      end
    end

    describe "POST /admin/users/:id/resend_invitation" do
      it "resends the invitation and redirects to the user" do
        post resend_invitation_admin_user_path(user)
        expect(response).to redirect_to(admin_user_path(user))
      end
    end
  end

  describe "as a non-admin user" do
    before do
      sign_in company_admin
    end

    describe "GET /admin/users" do
      it "redirects to the root path" do
        get admin_users_path
        expect(response).to redirect_to(root_path)
      end
    end

    describe "POST /admin/users" do
      it "does not create a user" do
        expect {
          post admin_users_path, params: { user: { email: 'newuser@example.com' } }
        }.not_to change(User, :count)
      end

      it "redirects to the root path" do
        post admin_users_path, params: { user: { email: 'newuser@example.com' } }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "when not logged in" do
    describe "GET /admin/users" do
      it "redirects to the login page" do
        get admin_users_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
