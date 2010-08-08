class CreateDeploys < ActiveRecord::Migration
  def self.up
    create_table :deploys do |t|
      t.integer :build_id
      t.integer :cluster_id
      t.string :user
      t.string :source
      t.string :callback
      t.boolean :force
      t.datetime :started_at
      t.datetime :completed_at
      t.boolean :status
      t.string :log_url

      t.timestamps
    end
  end

  def self.down
    drop_table :deploys
  end
end
