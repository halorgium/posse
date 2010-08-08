filename = Rails.root + '/config/resque.yml'
if File.exists?(filename)
  config = YAML.load_file(filename)
  Resque.redis = config[Rails.env]
end
