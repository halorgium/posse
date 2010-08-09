# This file is auto-generated from the current state of the database. Instead 
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your 
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100809013746) do

  create_table "branches", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "builds", :force => true do |t|
    t.integer  "commit_id"
    t.integer  "branch_id"
    t.integer  "exit_status"
    t.text     "output"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clusters", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.string   "cloud_name"
    t.string   "data_url"
    t.string   "default_branch"
    t.string   "branch_restriction"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "irc_name"
  end

  create_table "commits", :force => true do |t|
    t.integer  "project_id"
    t.string   "identifier"
    t.string   "message"
    t.string   "author"
    t.datetime "commited_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deploys", :force => true do |t|
    t.integer  "build_id"
    t.integer  "cluster_id"
    t.string   "user"
    t.string   "source"
    t.boolean  "force"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.string   "log_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exit_status"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "git_uri"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
