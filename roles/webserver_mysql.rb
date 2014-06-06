name "webserver_mysql"
description "Web server role with local mysql"
all_env = [ 
	"role[webserver]",
	"recipe[mysql]",
	"recipe[mysql::ruby]",
	"recipe[mysql::server]",
	"recipe[database]",
]

run_list(all_env)

env_run_lists(
	"_default" => all_env, 
	"prod" => all_env,
	#"dev" => all_env + ["recipe[php:module_xdebug]"],
	"dev" => all_env,
) 
