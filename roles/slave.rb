name "ci_slave_webserver"
description "CI Slave Web server role"
all_env = [
  "recipe[slave-ci::mysql]",
  "recipe[phantomjs::default]",
  "recipe[yum-epel::default]",
  "role[webserver]",
  "recipe[webserver-dev-chef::default]",
  "recipe[webserver-dev-chef::xdebug]",
  "recipe[webserver-dev-chef::drush]",
  "recipe[webserver-dev-chef::pear_tools]",
  "recipe[maven::default]",
  "recipe[slave-ci::default]",
]

run_list(all_env)

env_run_lists(
  "_default" => all_env, 
  "prod" => all_env,
  "dev" => all_env,
)

override_attributes(
  "maven" => {
     "version"   => 3,
     "setup_bin" => true
  },
  "php" => {
     "directives" => {
        "memory_limit" => "1G",
        "date.timezone" => "Europe/London"
     }
  },
  "mysql" => {
     "bind_address"           => "0.0.0.0",
     "server_debian_password" => "nationaltheatre",
     "server_root_password"   => "nationaltheatre",
     "server_repl_password"   => "repl_password",
     "remove_anonymous_users" => true,
     "remove_test_database"   => true,
     "data_dir"               => "/mnt/mysql",
     "tunable" => {
        "max_allowed_packet" => "100M",
        "log_warnings" => false,
        "net_read_timeout" => 60,
        "wait_timeout" => 28800
     }
  },
  "nodejs" => {
    "version" => "0.10.26",
    "checksum_linux_x64" => "305bf2983c65edea6dd2c9f3669b956251af03523d31cf0a0471504fd5920aac",
  }
) 
