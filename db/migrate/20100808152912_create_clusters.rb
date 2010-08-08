class CreateClusters < ActiveRecord::Migration
  def self.up
    create_table :clusters do |t|
      t.integer :project_id
      t.string :name
      t.string :cloud_name
      t.string :data_url
      t.string :default_branch
      t.string :branch_restriction

      t.timestamps
    end
  end

  def self.down
    drop_table :clusters
  end
end
