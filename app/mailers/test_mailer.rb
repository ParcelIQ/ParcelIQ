class TestMailer < ApplicationMailer
  default from: "devteam@myparceliq.com"

  def hello
    mail(
      subject: "Hello from Postmark",
      to: "devteam@myparceliq.com",
      from: "devteam@myparceliq.com",
      html_body: "<strong>Hello</strong> dear Postmark user.",
      track_opens: "true",
      message_stream: "outbound")
  end
end
