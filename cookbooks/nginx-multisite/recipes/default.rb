include_recipe 'nginx-multisite::security'
include_recipe 'nginx-multisite::nginx'
include_recipe 'nginx-multisite::ssl'
include_recipe 'nginx-multisite::sites'

ourdata '10.0.0.78 myfakehost'