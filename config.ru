# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

map "/github" do
  app = Github::PostReceive.new do |payload|
    Project.handle(payload)
  end
  run app
end

map "/" do
  run Posse::Application
end
