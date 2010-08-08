on_utilities "resque" do
  sudo "god signal resque-#{app} QUIT"
end
