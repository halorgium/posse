class Cluster < ActiveRecord::Base
  validates_uniqueness_of :name, :scope => :project_id

  belongs_to :project
end
