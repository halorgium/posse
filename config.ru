# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

use HoptoadNotifier::Rack

map "/github" do
  app = Github::PostReceive.new do |payload|
    Project.handle(payload)
  end
  run app
end

map "/irc" do
  app = Irc::Receiver.new do |payload|
    Message.handle(payload)
  end
  run app
end

map "/resque" do
  run Resque::Server
end

map "/" do
  run Posse::Application
end
