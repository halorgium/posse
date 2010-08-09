class Branch < ActiveRecord::Base
  validates_uniqueness_of :name, :scope => :project_id

  belongs_to :project
  has_many :builds

  def build(commit)
    build = builds.new(:commit_id => commit.id)
    build.save!
    build.run
  end

  def deploy(request, cluster)
    if current_build
      if current_build.succeeded? || request.force
        current_build.deploy(request, cluster)
      else
        request.reply("#{project_name} @ #{name} not green")
      end
    else
      request.reply("#{project_name} @ #{name} has no builds")
    end
  end

  def current_status
    current_build ? current_build.status : "idle"
  end

  def current_build
    builds.order(:updated_at).reverse_order.first
  end

  def project_name
    project.name
  end
end
