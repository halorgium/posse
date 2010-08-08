class AddClusterIrcName < ActiveRecord::Migration
  def self.up
    add_column :clusters, :irc_name, :string
  end

  def self.down
    remove_column :clusters, :irc_name
  end
end
