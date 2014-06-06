name "webserver_mongodb"
description "Web server role with mongodb"
all_env = [ 
	"role[webserver]",
	"recipe[webserver-chef::mongodb_client]",
]

run_list(all_env)

env_run_lists(
	"_default" => all_env, 
	"prod" => all_env,
	#"dev" => all_env + ["recipe[php:module_xdebug]"],
	"dev" => all_env,
) 
