ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "localhost",
  :user_name            => "zenon.alex@gmail.com",
  :password             => "rdls112a",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
