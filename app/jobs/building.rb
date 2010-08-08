class Building < Resque::AbstractJob
  def self.perform(id)
    Build.find(id).run!
  end
end
