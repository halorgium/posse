class RemoveCallback < ActiveRecord::Migration
  def self.up
    remove_column :deploys, :callback
  end

  def self.down
    add_column :deploys, :callback, :string
  end
end
