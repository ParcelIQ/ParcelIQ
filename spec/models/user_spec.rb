require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:role) }

    it "requires company for customer users" do
      user = build(:user, role: 'customer', company: nil)
      expect(user).not_to be_valid
      expect(user.errors[:company]).to include("can't be blank")
    end

    it "does not require company for admin users" do
      user = build(:user, role: 'admin', company: nil)
      expect(user).to be_valid
    end

    it "validates role inclusion" do
      should validate_inclusion_of(:role).in_array([ "admin", "customer" ])
    end
  end

  describe "associations" do
    it { should belong_to(:company).optional }
  end

  describe "multitenancy" do
    it "is scoped by tenant when tenant is present and user is customer" do
      company = create(:company)
      ActsAsTenant.current_tenant = company
      expect(User.scoped_by_tenant?).to be_truthy
      ActsAsTenant.current_tenant = nil
    end

    it "is not scoped by tenant when tenant is not present" do
      ActsAsTenant.current_tenant = nil
      expect(User.scoped_by_tenant?).to be_falsey
    end
  end

  describe "helper methods" do
    it "identifies admin users correctly" do
      admin = build(:user, role: 'admin')
      customer = build(:user, role: 'customer')
      expect(admin.admin?).to be_truthy
      expect(customer.admin?).to be_falsey
    end

    it "identifies customer users correctly" do
      admin = build(:user, role: 'admin')
      customer = build(:user, role: 'customer')
      expect(admin.customer?).to be_falsey
      expect(customer.customer?).to be_truthy
    end

    it "provides backward compatibility for root_admin?" do
      admin = build(:user, role: 'admin')
      expect(admin.root_admin?).to eq(admin.admin?)
    end
  end

  describe "authentication" do
    it "finds user by email regardless of tenant" do
      user = create(:user, email: 'test@example.com')
      found_user = User.find_for_authentication(email: 'test@example.com')
      expect(found_user).to eq(user)
    end
  end
end
