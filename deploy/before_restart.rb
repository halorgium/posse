on_app_servers do
  env_custom = "#{shared_path}/config/env.custom"
  run "echo 'export APP_CURRENT_PATH=\"#{current_path}\"' > #{env_custom}"
  run "echo 'export UNICORN_EXEC=\"#{current_path}/shell/unicorn\"' >> #{env_custom}"
end
