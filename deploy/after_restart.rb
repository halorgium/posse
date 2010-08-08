on_utilities "resque" do
  sudo "god signal resque QUIT"
end
