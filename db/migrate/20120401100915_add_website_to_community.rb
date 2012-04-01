class AddWebsiteToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :website_url, :string
  end

  def self.down
    remove_column :communities, :website_url
  end
end
