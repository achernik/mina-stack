task :defaults do

  set_default :term_mode,             :pretty
  set :shared_path,                   current_path
  set :shared_paths,                  []
  set :releases_path,                 'current'

  set_default :ruby_version,          "2.1.0-p0"
  set_default :services_path,         "/etc/init.d"
  set_default :upstart_path,          "/etc/init"
  set_default :deploy_path,           "#{deploy_to}/#{current_path}"
  set_default :tmp_path,              "#{deploy_path}/tmp"
  set_default :sockets_path,          "#{tmp_path}/sockets"
  set_default :pids_path,             "#{tmp_path}/pids"
  set_default :logs_path,             "#{deploy_path}/log"
  set_default :config_path,           "#{deploy_path}/config"
  set_default :bundle,                "cd #{deploy_path} && #{bundle_bin}"

  set_default :nginx_path,            '/etc/nginx'
  set_default :nginx_pid,             "/var/run/nginx.pid"
  set_default :nginx_config,          "#{nginx_path!}/sites-available/#{app!}.conf"
  set_default :nginx_config_e,        "#{nginx_path!}/sites-enabled/#{app!}.conf"

  set_default :psql_version,          "9.3"
  set_default :psql_user,             "#{app!}"
  set_default :psql_database,         "#{app!}"
  set_default :psql_pid,              "/var/run/postgresql/#{psql_version}-main.pid"

  set_default :memcached_pid,         "/var/run/memcached.pid"

  set_default :puma_name,             "puma_#{app!}"
  set_default :puma_cmd,              lambda { "#{bundle} exec puma" }
  set_default :pumactl_cmd,           lambda { "#{bundle} exec pumactl" }
  set_default :puma_config,           "#{config_path}/puma.rb"
  set_default :puma_pid,              "#{pids_path}/puma.pid"
  set_default :puma_log,              "#{logs_path}/puma.log"
  set_default :puma_error_log,        "#{logs_path}/puma.err.log"
  set_default :puma_socket,           "#{sockets_path}/puma.sock"
  set_default :puma_state,            "#{sockets_path}/puma.state"
  set_default :puma_upstart,          "#{upstart_path!}/#{puma_name}.conf"
  set_default :puma_workers,          2

  set_default :unicorn_name,          "unicorn_#{app!}"
  set_default :unicorn_socket,        "#{sockets_path}/unicorn.sock"
  set_default :unicorn_pid,           "#{pids_path}/unicorn.pid"
  set_default :unicorn_config,        "#{config_path}/unicorn.rb"
  set_default :unicorn_log,           "#{logs_path}/unicorn.log"
  set_default :unicorn_error_log,     "#{logs_path}/unicorn.error.log"
  set_default :unicorn_script,        "#{services_path!}/#{unicorn_name}"
  set_default :unicorn_workers,       1
  set_default :unicorn_bin,           lambda { "#{bundle_bin} exec unicorn" }
  set_default :unicorn_cmd,           "cd #{deploy_path} && #{unicorn_bin} -D -c #{unicorn_config} -E #{rails_env}"
  set_default :unicorn_user,          user
  set_default :unicorn_group,         user

  set_default :sidekiq_name,          "sidekiq_#{app!}"
  set_default :sidekiq_cmd,           lambda { "#{bundle_bin} exec sidekiq" }
  set_default :sidekiqctl_cmd,        lambda { "#{bundle_prefix} sidekiqctl" }
  set_default :sidekiq_timeout,       10
  set_default :sidekiq_config,        "#{config_path}/sidekiq.yml"
  set_default :sidekiq_log,           "#{logs_path}/sidekiq.log"
  set_default :sidekiq_pid,           "#{pids_path}/sidekiq.pid"
  set_default :sidekiq_concurrency,   10
  # set_default :sidekiq_start,         "(cd #{deploy_path}; nohup #{sidekiq_cmd} -e #{rails_env} -C #{sidekiq_config} -P #{sidekiq_pid} >> #{sidekiq_log} 2>&1 </dev/null &)"
  set_default :sidekiq_start,         "#{sidekiq_cmd} -e #{rails_env} -C #{sidekiq_config} -P #{sidekiq_pid} >> #{sidekiq_log}"
  set_default :sidekiq_upstart,       "#{upstart_path!}/#{sidekiq_name}.conf"
  # set_default :sidekiq_stop,          "(cd #{deploy_path} && #{sidekiqctl_cmd} stop #{sidekiq_pid} #{sidekiq_timeout})"

  set_default :private_pub_name,      "private_pub_#{app}"
  set_default :private_pub_cmd,       lambda { "#{bundle_prefix} rackup private_pub.ru" }
  set_default :private_pub_pid,       "#{pids_path}/private_pub.pid"
  set_default :private_pub_config,    "#{config_path}/private_pub.yml"
  set_default :private_pub_log,       "#{logs_path}/private_pub.log"

  set_default :monit_config_path,     "/etc/monit/conf.d"
  set_default :monit_http_port,       2812
  set_default :monit_http_username,   "PleaseChangeMe_monit"
  set_default :monit_http_password,   "PleaseChangeMe"

  set_default :server_stack,          %w(
                                        nginx
                                        postgresql
                                        redis
                                        memcached
                                        imagemagick
                                      )

  set_default :app_stack,             %w(
                                        puma
                                        sidekiq
                                      )

  set_default :utils,                 %w(
                                        rbenv
                                        node
                                        bower
                                        monit
                                      )


  set_default :monitored, lambda { server_stack! + app_stack! }

end