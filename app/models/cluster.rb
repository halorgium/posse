class Cluster < ActiveRecord::Base
  validates_presence_of :name, :cloud_name
  validates_uniqueness_of :name, :scope => :project_id

  belongs_to :project

  def current_status
    "running"
  end

  def default_branch
    read_attribute(:default_branch) || "master"
  end
end
