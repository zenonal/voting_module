if ENV['RAILS_ENV'] == 'development'
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "localhost",
  :user_name            => "info@jegouverne.be",
  :password             => "28rM1000Bxl",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
else
        ActionMailer::Base.smtp_settings = {
          :address              => "smtp.gmail.com",
          :port                 => 587,
          :domain               => "votingmodule.heroku.com",
          :user_name            => "info@jegouverne.be",
          :password             => "28rM1000Bxl",
          :authentication       => "plain",
          :enable_starttls_auto => true
        }
end