name "ci_slave_webserver"
description "CI Slave Web server role"
all_env = [ 
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
     "bind_address" => "0.0.0.0",
     "tunable" => {
        "max_allowed_packet" => "100M",
        "log_warnings" => false,
        "net_read_timeout" => 60,
        "wait_timeout" => 28800
     }
  },
  "nodejs" => {
    "version" => "0.10.5",
    "checksum" => "1c22bd15cb13b1109610ee256699300ec6999b335f3bc85dc3c0312ec9312cfd",
    "checksum_linux_x64" => "182b0992401ff04a288b5777e2892f14d912a509a6c15edc7c0daded3a20d3c7",
    "checksum_linux_x86" => "c8bb5e5be76b837115a6f581ac5719586da51a8168ead2c0f8e13d9977ab06bb",
  }
) 
