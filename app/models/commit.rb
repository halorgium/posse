class Commit < ActiveRecord::Base
  validates_uniqueness_of :identifier, :scope => :project_id

  belongs_to :project
end
