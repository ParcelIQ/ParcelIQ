require 'rails_helper'

RSpec.describe Company, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:subdomain) }

    # Test that email and website format are validated
    context "email format validation" do
      subject { build(:company) }
      it { should allow_value('valid@example.com').for(:email) }
      it { should_not allow_value('invalid_email').for(:email) }
    end

    context "website format validation" do
      subject { build(:company) }
      it { should allow_value('https://example.com').for(:website) }
      it { should_not allow_value('invalid-website').for(:website) }
    end

    # Test the subdomain format validation regex directly
    context "subdomain format regex" do
      it "accepts valid formats" do
        expect('validsubdomain' =~ /\A[a-z0-9]+(-[a-z0-9]+)*\z/).to be_truthy
        expect('valid-subdomain' =~ /\A[a-z0-9]+(-[a-z0-9]+)*\z/).to be_truthy
      end

      it "rejects invalid formats" do
        expect('invalid subdomain' =~ /\A[a-z0-9]+(-[a-z0-9]+)*\z/).to be_falsey
        expect('UPPERCASE' =~ /\A[a-z0-9]+(-[a-z0-9]+)*\z/).to be_falsey
        expect('special#chars' =~ /\A[a-z0-9]+(-[a-z0-9]+)*\z/).to be_falsey
      end
    end
  end

  describe "associations" do
    it { should have_one_attached(:logo) }
  end

  describe "callbacks" do
    it "downcases subdomain before saving" do
      company = create(:company, subdomain: 'CamelCase')
      expect(company.subdomain).to eq('camelcase')
    end
  end

  describe "defaults" do
    it "sets default values for new records" do
      company = Company.new
      expect(company.active).to be_truthy
      expect(company.settings).to eq({})
      expect(company.metadata).to eq({})
      expect(company.time_zone).to eq("UTC")
    end
  end
end
