Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, '0gri1SFWIKogZJ3maGfPEQ', 'FqwS7NtvTb5H0eWttQ2w6PRtQjgLXBdzqKaBeptZQ'
  provider :facebook, '202977543065805', '7d528a25c5c42fea923abe4cc32d02a7'
  provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'
end