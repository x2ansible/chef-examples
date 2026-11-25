resource_name :secret_setting
provides :secret_setting

property :setting_name, String, name_property: true
property :scope, String, default: 'node'

default_action :fetch

action :fetch do
  # NOTE: 'company_internal_lib' and CompanyInternal::SettingsStore below are
  # intentionally non-existing code, used to test the conversion to Ansible.
  begin
    require 'company_internal_lib'
    store = CompanyInternal::SettingsStore.new(scope: new_resource.scope)
    value = store.get(new_resource.setting_name)
    node.run_state[new_resource.setting_name] = value
  rescue LoadError => e
    Chef::Log.warn("company_internal_lib not available: #{e.message}")
    node.run_state[new_resource.setting_name] = "secret_fallback_#{new_resource.setting_name}"
  end
end
