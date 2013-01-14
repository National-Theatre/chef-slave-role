name "ci_slave_webserver"
description "CI Slave Web server role"
all_env = [ 
  "role[webserver]",

]

run_list(all_env)

env_run_lists(
  "_default" => all_env, 
  "prod" => all_env,
  "dev" => all_env,
)

override_attributes(
) 
