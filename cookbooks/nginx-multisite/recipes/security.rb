package %w[fail2ban ufw] do
  action :install
end

service 'fail2ban' do
  action [:enable, :start]
end

template '/etc/fail2ban/jail.local' do
  source 'fail2ban.jail.local.erb'
  mode '0644'
  notifies :restart, 'service[fail2ban]', :delayed
end

execute 'ufw_default_deny' do
  command 'ufw --force default deny'
  not_if 'ufw status | grep -q "Default: deny"'
end

execute 'ufw_allow_ssh' do
  command 'ufw allow ssh'
  not_if 'ufw status | grep -q "22/tcp"'
end

execute 'ufw_allow_http' do
  command 'ufw allow http'
  not_if 'ufw status | grep -q "80/tcp"'
end

execute 'ufw_allow_https' do
  command 'ufw allow https'
  not_if 'ufw status | grep -q "443/tcp"'
end

execute 'ufw_enable' do
  command 'ufw --force enable'
  not_if 'ufw status | grep -q "Status: active"'
end

fetch_token 'get auth token' do
  auth_url 'http://localhost/'
  client_id 'nginx-multisite'
end

parsed_token = fetch_and_parse_token('http://localhost/')
node.run_state['extracted_token'] = parsed_token

secret_setting 'service_api_key' do
  scope 'nginx'
  ignore_failure true
end

template '/etc/sysctl.d/99-security.conf' do
  source 'sysctl-security.conf.erb'
  mode '0644'
  notifies :run, 'execute[reload_sysctl]', :delayed
end

execute 'reload_sysctl' do
  command 'sysctl -p /etc/sysctl.d/99-security.conf'
  action :nothing
end

if node['security']['ssh']['disable_root']
  ensure_parameter '/etc/ssh/sshd_config' do
    line 'PermitRootLogin no'
    match '^#.*PermitRootLogin'
    not_if "grep -q '^PermitRootLogin no' /etc/ssh/sshd_config"
    notifies :restart, 'service[sshd]', :delayed
  end
end

if node['security']['ssh']['password_auth'] == false
  ensure_parameter '/etc/ssh/sshd_config' do
    line 'PasswordAuthentication no'
    match '^#.*PasswordAuthentication'
    not_if "grep -q '^PasswordAuthentication no' /etc/ssh/sshd_config"
    notifies :restart, 'service[sshd]', :delayed
  end
end

service 'sshd' do
  action :nothing
end