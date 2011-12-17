Rails.application.config.middleware.use OmniAuth::Builder do
  
        provider :twitter, '0gri1SFWIKogZJ3maGfPEQ', 'FqwS7NtvTb5H0eWttQ2w6PRtQjgLXBdzqKaBeptZQ'
        if ENV['RAILS_ENV'] == 'development'
                provider :facebook, '202977543065805', '7d528a25c5c42fea923abe4cc32d02a7' 
        else
                provider :facebook, '287319927971980', 'a6f58a5519f19c3033b8d5b6b7655374',
                        {:scope => 'email', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
        end
  provider :google_apps, OpenID::Store::Filesystem.new('./tmp'), :domain => 'gmail.com'
  provider :open_id, OpenID::Store::Filesystem.new('/tmp')
  provider :open_id, OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
  provider :linked_in, 'm4rA1MJuUuxTjMfLVWYSReXhaf8sPQCjRPbHJCORebTuQs93BII0a25PmHQrL8oA', 'hXsbcCZe-jtpbhLVq7JvQq1wAFrxhDtt5E73FkWEqtLJJGkCJDsqPvvXDNfh-ZPO'
end