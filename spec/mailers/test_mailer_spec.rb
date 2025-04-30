require "rails_helper"

RSpec.describe TestMailer, type: :mailer do
  describe "hello" do
    let(:mail) { TestMailer.hello }

    it "renders the headers" do
      expect(mail.subject).to eq("Hello")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
