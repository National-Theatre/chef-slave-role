name "ci_slave_webserver"
description "CI Slave Web server role"
all_env = [ 
  "role[webserver]",
  "recipe[webserver-dev-chef::default]",
  "recipe[webserver-dev-chef::xdebug]",
  "recipe[webserver-dev-chef::drush]",
  "recipe[webserver-dev-chef::pear_tools]",
  "recipe[maven::default]",
  "recipe[java::default]",
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
  }
) 
