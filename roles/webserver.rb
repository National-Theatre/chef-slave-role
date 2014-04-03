name "webserver"
description "Web server role"
all_env = [ 
	"role[base]",
	"recipe[webserver-chef::php_config]",
	"recipe[php]",
	"recipe[apache2]",
	"recipe[webserver-chef::mod_php5]",
	"recipe[apache2::mod_rewrite]",
        "recipe[apache2::mod_expires]",
	"recipe[webserver-chef]",
        "recipe[newrelic::php-agent]",
]

run_list(all_env)

env_run_lists(
	"_default" => all_env, 
	"prod" => all_env,
	#"dev" => all_env + ["recipe[php:module_xdebug]"],
	"dev" => all_env,
)

override_attributes(
  "php" => {
     "directives" => {
        "date.timezone" => "Europe/London"
     }
  },
  "newrelic" => {
    "application_monitoring" => {
      "enabled"        => true,
      "capture_params" => true,
    }
  }
)