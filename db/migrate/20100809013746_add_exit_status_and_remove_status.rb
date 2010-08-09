class AddExitStatusAndRemoveStatus < ActiveRecord::Migration
  def self.up
    add_column :deploys, :exit_status, :integer
    remove_column :deploys, :status
  end

  def self.down
    add_column :deploys, :status, :boolean
    remove_column :deploys, :exit_status
  end
end
