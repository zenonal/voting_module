Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, '0gri1SFWIKogZJ3maGfPEQ', 'FqwS7NtvTb5H0eWttQ2w6PRtQjgLXBdzqKaBeptZQ'
  provider :facebook, '202977543065805', '7d528a25c5c42fea923abe4cc32d02a7' if ENV['RAILS_ENV'] == 'development'
  provider :facebook, '112773305478994', 'dca7a2c9691e5f513909f89efbd190a5' if ENV['RAILS_ENV'] == 'production'
end