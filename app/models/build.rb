class Build < ActiveRecord::Base
  belongs_to :commit
  belongs_to :branch

  def run
    Rails.logger.info "Building #{commit.identifier} on #{branch.name} for #{project.name}"
  end

  def project
    branch.project
  end
end
