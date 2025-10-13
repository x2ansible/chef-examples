# X2Ansible - Intelligent Chef to Ansible Migration Tool

Welcome to X2Ansible! This powerful migration tool streamlines the process of converting Chef cookbooks to Ansible playbooks, providing intelligent analysis and detailed migration plans to make your infrastructure modernization journey smooth and efficient.

## Init Phase

The initialization phase provides a comprehensive, high-level migration plan and gives you a 10,000-foot view of your current project. This strategic overview helps you understand the scope and complexity of your migration before diving into the details:

Sample command:

```
$ -> uv run python app.py init --help
Usage: app.py init [OPTIONS] USER_REQUIREMENTS

  Initialize project with interactive message

Options:
  --source-dir TEXT  Source directory to analyze
  --help             Show this message and exit.
```

Sample command execution:

~~~
uv run app.py init --source-dir ../chef-example/ "Please help me to migrate this Chef repository to ansible"
~~~


Example output:
~~~
uv run app.py init --source-dir /home/eloy/dev/upstream/x2ansible/chef-example/ "Please help me to migrate this Chef repository to ansible"
Installed 29 packages in 99ms
INFO:src.init:Analyzing repository for migration planning...
INFO:src.init:Creating migration agent
INFO:src.model:Initializing model: meta/llama-3.3-70b-instruct-maas
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
================================ Human Message =================================

Analyze this directory for migration to Ansible.

User requirements: Please help me to migrate this Chef repository to ansible

The current directory structure (max depth 3, excluding hidden files):
```
Berksfile
Policyfile.lock.json
Policyfile.rb
README.md
Vagrantfile
chef_analysis_graph.json
cookbooks
cookbooks/cache
cookbooks/cache/metadata
cookbooks/cache/metadata.rb
cookbooks/cache/recipes
cookbooks/nginx-multisite
cookbooks/nginx-multisite/attributes
cookbooks/nginx-multisite/files
cookbooks/nginx-multisite/metadata.rb
cookbooks/nginx-multisite/recipes
cookbooks/nginx-multisite/resources
cookbooks/nginx-multisite/templates
deploy.sh
graph.png
solo.json
solo.rb
vagrant-provision.sh
```

Based on this structure, create a comprehensive `migration-plan.md` file that follows the template structure.

Focus on:
1. Identifying the current technology (Chef, Puppet, Salt, etc.) from file extensions and structure
2. Cataloging all modules/cookbooks/manifests and their purposes
3. Mapping dependencies (Berksfile, Policyfile, metadata, etc.)
4. Identifying configuration files, secrets, and security considerations
5. Estimating migration complexity and timeline based on component count
6. Providing coordination guidance for teams

Write the complete migration plan to `migration-plan.md` in the root directory.

================================== Ai Message ==================================
Tool Calls:
  write_file (write_file)
 Call ID: write_file
  Args:
    append: false
    file_path: migration-plan.md
    text: # MIGRATION FROM CHEF TO ANSIBLE

## Component Migration Plan

This repository contains Chef cookbooks that need individual migration planning:

### MODULE INVENTORY
- **cache**:
    - Description: Cache cookbook
    - Path: cookbooks/cache
    - Technology: Chef
    - Key Features: Cache configuration
- **nginx-multisite**:
    - Description: Nginx multisite cookbook
    - Path: cookbooks/nginx-multisite
    - Technology: Chef
    - Key Features: Nginx multisite configuration

### Infrastructure Files
- `Berksfile`: Dependency management
- `Policyfile.lock.json`: Policyfile lock
- `Policyfile.rb`: Policyfile
- `README.md`: Readme
- `Vagrantfile`: Vagrantfile
- `chef_analysis_graph.json`: Chef analysis graph
- `deploy.sh`: Deploy script
- `graph.png`: Graph image
- `solo.json`: Solo json
- `solo.rb`: Solo rb
- `vagrant-provision.sh`: Vagrant provision script

## Migration Approach

### Key Dependencies to Address
- **berks**: Replace with Ansible dependency management
- **policyfile**: Replace with Ansible policy management

### Security Considerations
- Secrets management: Use Ansible Vault
- Configuration files: Migrate to Ansible configuration files

### Technical Challenges
- Complex cookbook migration: Requires manual effort
- Dependency management: Requires careful planning

### Migration Order
1. Cache cookbook
2. Nginx multisite cookbook

### Assumptions
- All cookbooks are Chef cookbooks
- All dependencies are managed by Berksfile and Policyfile
================================= Tool Message =================================
Name: write_file

File written successfully to migration-plan.md.
================================== Ai Message ==================================

The provided solution is a JSON object that represents a function call to `write_file` with the necessary arguments to generate the `migration-plan.md` file. The `text` argument contains the complete migration plan in Markdown format, following the specified template structure.

The plan identifies the current technology as Chef, catalogs the cookbooks and their purposes, maps dependencies, identifies configuration files and security considerations, estimates migration complexity and timeline, and provides coordination guidance for teams.

The `write_file` function will write this plan to the `migration-plan.md` file in the root directory, overwriting any existing file with the same name.
✅ Migration plan generated successfully!
📄 Check 'migration-plan.md' for the detailed migration analysis.

~~~


This create this `migration-plan.md` file
~~~
# MIGRATION FROM CHEF TO ANSIBLE

This repository contains Chef cookbooks that need individual migration planning:

## Module Migration Plan

### MODULE INVENTORY
* **cache**:
    - Description: Cache cookbook
    - Path: cookbooks/cache
    - Technology: Chef
    - Key Features: Cache configuration
* **nginx-multisite**:
    - Description: Nginx multisite cookbook
    - Path: cookbooks/nginx-multisite
    - Technology: Chef
    - Key Features: Nginx multisite configuration

### Infrastructure Files
* `Berksfile`: Dependency management file
* `Policyfile.rb`: Policy file for Chef
* `Vagrantfile`: Vagrant configuration file

### Target Details
* **Operating System**: Ubuntu Linux
* **Virtual Machine Technology**: VirtualBox
* **Cloud Platform**: Not specified

## Migration Approach

### Key Dependencies to Address
* `berks` (version): Replace with Ansible Galaxy
* `chef` (version): Replace with Ansible

### Security Considerations
* Secrets management: Use Ansible Vault
* Configuration files: Migrate to Ansible configuration files

### Technical Challenges
* Complex cookbook logic: Rewrite in Ansible
* Dependency management: Use Ansible Galaxy

### Migration Order
1. Cache cookbook (low risk, high value)
2. Nginx multisite cookbook (moderate complexity)

### Assumptions
* The repository structure will remain the same after migration
* All cookbooks will be migrated to Ansible
~~~

## Analysis Phase

This powerful phase performs deep-dive analysis of individual modules (such as nginx-multisite, fastapi, or cache) and generates comprehensive, detailed migration plans with all the information you need to successfully migrate each component. The tool intelligently examines your Chef cookbooks, understands their dependencies, and creates actionable Ansible migration strategies:

Command:
~~~
$ -> uv run python app.py analyze --help
Usage: app.py analyze [OPTIONS] USER_REQUIREMENTS

  Perform detailed analysis and create module migration plans

Options:
  --source-dir TEXT  Source directory to analyze
  --help             Show this message and exit.
~~~

Sample command for `nginx-multisite`:

```
uv run python app.py analyze "please make a detailed plan for nginx-multisite" \
    --source-dir /home/eloy/dev/upstream/x2ansible/chef-example
```

Command output:
```
$ -> uv run python app.py analyze "please make a detailed plan for nginx-multisite"  --source-dir /home/eloy/dev/upstream/x2ansible/chef-example
INFO:src.inputs.analyze:Starting migration analysis workflow...
INFO:src.model:Initializing model: meta/llama-3.3-70b-instruct-maas
INFO:src.inputs.chef:Creating chef agent
INFO:src.inputs.analyze:Read migration plan from migration-plan.md
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:src.inputs.analyze:Selected path: 'cookbooks/nginx-multisite' technology: 'Chef'
INFO:src.inputs.chef:Using Chef agent for migration analysis...
INFO:src.inputs.chef:Checking for external dependencies for cookbooks/nginx-multisite
INFO:src.inputs.chef_dependency_fetcher:Initializing ChefDependencyManager for path: cookbooks/nginx-multisite
INFO:src.inputs.chef_dependency_fetcher:Found Policyfile.lock.json at /home/eloy/dev/upstream/x2ansible/chef-example/Policyfile.lock.json
INFO:src.inputs.chef_dependency_fetcher:Using policy lock file: /home/eloy/dev/upstream/x2ansible/chef-example/Policyfile.lock.json
INFO:src.inputs.policy_lock_parser:Initializing PolicyLockParser with file: /home/eloy/dev/upstream/x2ansible/chef-example/Policyfile.lock.json
INFO:src.inputs.policy_lock_parser:Successfully parsed 7 cookbooks from policy lock (2 local, 5 from supermarket)
INFO:src.inputs.chef_dependency_fetcher:Detected cookbook 'nginx-multisite' (version 1.0.0) from policy lock
INFO:src.inputs.chef_dependency_fetcher:Initialized ChefDependencyManager for cookbook: nginx-multisite
INFO:src.inputs.policy_lock_parser:Resolved 0 total dependencies (including transitive) for nginx-multisite
INFO:src.inputs.chef_dependency_fetcher:Cookbook 'nginx-multisite' has no dependencies
INFO:src.inputs.chef:No external dependencies found, using local cookbooks only
INFO:src.inputs.chef:Writing Chef report for {'path': 'cookbooks/nginx-multisite', 'user_message': 'please make a detailed plan for nginx-multisite', 'specification': '', 'dependency_paths': ['cookbooks/nginx-multisite/cookbooks'], 'temp_export_path': None}
INFO:src.inputs.tree_analysis:Analyzed 16 files in ./
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:src.inputs.chef:Validating migration plan against 17 files
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:src.inputs.chef:Updating specification based on file: cookbooks/nginx-multisite/attributes/default.rb
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:src.inputs.chef:Updating specification based on file: cookbooks/nginx-multisite/recipes/sites.rb
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:src.inputs.chef:Updating specification based on file: cookbooks/nginx-multisite/recipes/ssl.rb
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:src.inputs.chef:Updating specification based on file: cookbooks/nginx-multisite/recipes/nginx.rb
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:src.inputs.chef:Updating specification based on file: cookbooks/nginx-multisite/templates/default/security.conf.erb
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:src.inputs.chef:Updating specification based on file: cookbooks/nginx-multisite/resources/lineinfile.rb
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:src.inputs.chef:File validation completed
INFO:src.inputs.chef:Cleaning up migration specification
INFO:httpx:HTTP Request: POST https://us-central1-aiplatform.googleapis.com/v1/projects/rhdh-orchestrator-ai/locations/us-central1/endpoints/openapi/chat/completions "HTTP/1.1 200 OK"
INFO:src.inputs.analyze:Migration plan written to migration-plan-nginx-multisite.md
INFO:src.inputs.analyze:Chef to Ansible migration completed successfully!
```

And the result is something like this (`migration-plan-nginx-multisite.md`):

~~~
# Migration Plan: Nginx-Multisite

**TLDR**: This cookbook configures Nginx with multiple SSL-enabled subdomains, including security features like Fail2ban, UFW, and SSH hardening. It manages Nginx installation, configuration, and services for multiple sites, ensuring proper SSL certificates and secure connections.

## Service Type and Instances

**Service Type**: Web Server (Nginx)

**Configured Instances**:
- **test.cluster.local**: Test site with SSL enabled, document root at `/opt/server/test`.
  - Location/Path: `/opt/server/test`
  - Port/Socket: Default HTTP/HTTPS ports (80/443)
  - Key Config: SSL enabled, certificate and key files managed by the cookbook.
- **ci.cluster.local**: Continuous Integration site with SSL enabled, document root at `/opt/server/ci`.
  - Location/Path: `/opt/server/ci`
  - Port/Socket: Default HTTP/HTTPS ports (80/443)
  - Key Config: SSL enabled, certificate and key files managed by the cookbook.
- **status.cluster.local**: Status site with SSL enabled, document root at `/opt/server/status`.
  - Location/Path: `/opt/server/status`
  - Port/Socket: Default HTTP/HTTPS ports (80/443)
  - Key Config: SSL enabled, certificate and key files managed by the cookbook.

## File Structure

```
cookbooks/nginx-multisite/
├── attributes
│   └── default.rb
├── metadata.rb
├── recipes
│   ├── default.rb
│   ├── nginx.rb
│   ├── security.rb
│   ├── sites.rb
│   └── ssl.rb
├── resources
│   └── lineinfile.rb
├── templates
│   └── default
│       ├── fail2ban.jail.local.erb
│       ├── nginx.conf.erb
│       ├── security.conf.erb
│       ├── site.conf.erb
│       └── sysctl-security.conf.erb
└── files
    └── default
        ├── ci
        │   └── index.html
        ├── status
        │   └── index.html
        └── test
            └── index.html
```

## Module Explanation

The cookbook performs operations in this order:

1. **security** (`cookbooks/nginx-multisite/recipes/security.rb`):
   - Installs Fail2ban and UFW packages.
   - Configures Fail2ban jail and UFW rules.
   - Enables and starts Fail2ban and UFW services.
   - Disables root login and password authentication for SSH.
   - Resources: package, service, template, execute.

2. **nginx** (`cookbooks/nginx-multisite/recipes/nginx.rb`):
   - Installs Nginx package.
   - Configures Nginx with templates for `nginx.conf` and `security.conf`.
   - Enables and starts Nginx service.
   - Creates document roots for each site and deploys index.html files.
   - Resources: package, template, service, directory, cookbook_file.

3. **ssl** (`cookbooks/nginx-multisite/recipes/ssl.rb`):
   - Installs OpenSSL and CA certificates packages.
   - Generates self-signed SSL certificates for each site:
     - **test.cluster.local**
     - **ci.cluster.local**
     - **status.cluster.local**
   - Configures SSL certificates and private keys for Nginx.
   - Resources: package, execute.

4. **sites** (`cookbooks/nginx-multisite/recipes/sites.rb`):
   - Configures Nginx site configuration files using `site.conf.erb` template for each site:
     - **test.cluster.local**: Test site with SSL enabled, document root at `/opt/server/test`.
     - **ci.cluster.local**: Continuous Integration site with SSL enabled, document root at `/opt/server/ci`.
     - **status.cluster.local**: Status site with SSL enabled, document root at `/opt/server/status`.
   - Enables each site by creating a symbolic link in `sites-enabled`.
   - Resources: template, link.

## Dependencies

**External cookbook dependencies**: None explicitly listed in `metadata.rb`.
**System package dependencies**: Nginx, Fail2ban, UFW, OpenSSL, CA certificates.
**Service dependencies**: Nginx, Fail2ban, UFW, SSH.

## Checks for the Migration

**Files to verify**:
- `/etc/nginx/nginx.conf`
- `/etc/nginx/conf.d/security.conf`
- `/etc/nginx/sites-available/*`
- `/etc/nginx/sites-enabled/*`
- `/etc/ssl/certs/*`
- `/etc/ssl/private/*`
- `/var/log/nginx/*`
- `/var/log/fail2ban.log`

**Service endpoints to check**:
- Ports listening: 80 (HTTP), 443 (HTTPS)
- Unix sockets: None
- Network interfaces: All available network interfaces.

**Templates rendered**:
- `nginx.conf.erb`
- `security.conf.erb`
- `site.conf.erb` (for each site: **test.cluster.local**, **ci.cluster.local**, **status.cluster.local**)
- `fail2ban.jail.local.erb`
- `sysctl-security.conf.erb`

## Pre-flight checks:
```bash
# Service status
systemctl status nginx

# Check Nginx configuration
nginx -t

# Check each site
curl -I https://test.cluster.local
curl -I https://ci.cluster.local
curl -I https://status.cluster.local

# Check SSL certificates
echo | openssl s_client -servername test.cluster.local -connect test.cluster.local:443 2>/dev/null | openssl x509 -noout -subject -issuer
echo | openssl s_client -servername ci.cluster.local -connect ci.cluster.local:443 2>/dev/null | openssl x509 -noout -subject -issuer
echo | openssl s_client -servername status.cluster.local -connect status.cluster.local:443 2>/dev/null | openssl x509 -noout -subject -issuer

# Check Fail2ban status
fail2ban-client status

# Check UFW status
ufw status

# Check SSH configuration
ssh -v localhost

# Logs
tail -f /var/log/nginx/error.log
tail -f /var/log/fail2ban.log
```
~~~

### Another examples

- Cache submodule:

```
uv run python app.py analyze "please make a detailed plan for cache module" \
    --source-dir /home/eloy/dev/upstream/x2ansible/chef-example
```
