class CreateCommits < ActiveRecord::Migration
  def self.up
    create_table :commits do |t|
      t.integer :project_id
      t.string :identifier
      t.string :message
      t.string :author
      t.datetime :commited_at

      t.timestamps
    end
  end

  def self.down
    drop_table :commits
  end
end
