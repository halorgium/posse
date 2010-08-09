class Deploying < Resque::AbstractJob
  def self.perform(id)
    Deploy.find(id).run!
  end
end
