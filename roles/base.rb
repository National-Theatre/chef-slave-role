name "base"
description "Base role applied to all nodes."
run_list(
  "recipe[sudo]",
  "recipe[cron]",
  "recipe[base-chef]",
  "recipe[newrelic::server-monitor-agent]",
) 
override_attributes(
  :authorization => {
    :sudo => {
      :users => ["ubuntu", "vagrant"],
      :passwordless => true
    }
  }
) 
