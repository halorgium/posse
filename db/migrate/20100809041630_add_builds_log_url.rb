class AddBuildsLogUrl < ActiveRecord::Migration
  def self.up
    add_column :builds, :log_url, :string
  end

  def self.down
    remove_column :builds, :log_url
  end
end
