class Branch < ActiveRecord::Base
  validates_uniqueness_of :name, :scope => :project_id

  belongs_to :project
  has_many :builds

  def build(commit)
    build = builds.new(:commit_id => commit.id)
    build.save!
    build.run
  end
end
