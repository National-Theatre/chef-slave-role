name "base"
description "Base role applied to all nodes."
run_list(
  "recipe[sudo]",
  "recipe[cron]",
  "recipe[base-chef]"
) 
override_attributes(
  :authorization => {
    :sudo => {
      :users => ["ubuntu", "vagrant"],
      :passwordless => true
    }
  }
) 
