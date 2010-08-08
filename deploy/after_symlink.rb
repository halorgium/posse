run "ln -nfs #{shared_path}/config/resque.yml #{latest_release}/config/resque.yml"

run "[ -f #{shared_path}/tmp/checkouts ] || mkdir -p #{shared_path}/tmp/checkouts"
run "ln -nfs #{shared_path}/tmp/checkouts #{latest_release}/tmp/checkouts"
