# MIGRATION FROM CHEF TO ANSIBLE

## Executive Summary

This repository contains a Chef-based infrastructure setup for a multi-site Nginx web server with caching services (Memcached and Redis) and a FastAPI application backed by PostgreSQL. The migration to Ansible will involve converting three Chef cookbooks with their dependencies to equivalent Ansible roles and playbooks.

**Estimated Timeline:**
- Analysis and Planning: 1 week
- Development of Ansible roles: 2-3 weeks
- Testing and Validation: 1-2 weeks
- Documentation and Knowledge Transfer: 1 week
- Total: 5-7 weeks

**Complexity Assessment:** Medium
- The repository has a clear structure with well-defined cookbooks
- External dependencies on community cookbooks need to be replaced with Ansible Galaxy roles
- Security configurations and SSL certificate management require careful handling
- Hardcoded credentials need to be migrated to Ansible Vault

## Module Migration Plan

This repository contains Chef cookbooks that need individual migration planning:

### MODULE INVENTORY

- **nginx-multisite**:
    - Description: Nginx web server with multiple SSL-enabled virtual hosts, security hardening, and site configuration
    - Path: cookbooks/nginx-multisite
    - Technology: Chef
    - Key Features: Multi-site configuration, SSL certificate generation, security hardening (fail2ban, ufw, sysctl)

- **cache**:
    - Description: Caching services configuration including Memcached and Redis with authentication
    - Path: cookbooks/cache
    - Technology: Chef
    - Key Features: Redis with password authentication, Memcached configuration

- **fastapi-tutorial**:
    - Description: Python FastAPI application deployment with PostgreSQL database backend
    - Path: cookbooks/fastapi-tutorial
    - Technology: Chef
    - Key Features: Git repository deployment, Python virtual environment, PostgreSQL database setup, systemd service configuration

### Infrastructure Files

- `Berksfile`: Dependency management file for Chef cookbooks. Lists both local and external cookbook dependencies with version constraints. Will be replaced by Ansible Galaxy requirements.yml.
- `Vagrantfile`: Defines the development VM using Fedora 42. Will need to be updated to use Ansible provisioner instead of Chef.
- `solo.json`: Contains the Chef run list and node attributes. Will be converted to Ansible group_vars or host_vars.
- `solo.rb`: Chef Solo configuration file. No direct Ansible equivalent needed.
- `vagrant-provision.sh`: Shell script to install Chef and run the cookbooks. Will be replaced by Ansible provisioning.

### Target Details

- **Operating System**: Fedora 42 (based on Vagrantfile), with support for Ubuntu 18.04+ and CentOS 7+ (based on cookbook metadata)
- **Virtual Machine Technology**: Libvirt (based on Vagrantfile configuration)
- **Cloud Platform**: Not specified, appears to be targeting on-premises or local development environment

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible's `nginx` module or community.general collection
- **memcached (~> 6.0)**: Replace with Ansible's `memcached` module or geerlingguy.memcached role
- **redisio (~> 7.2.4)**: Replace with geerlingguy.redis role or custom Ansible role

### Security Considerations

- **Firewall Configuration**: The Chef cookbook configures UFW. Migration should use Ansible's `ufw` module or `firewalld` module depending on the target OS.
- **fail2ban Setup**: Currently configured in the nginx-multisite cookbook. Use Ansible's `fail2ban` module or a community role.
- **SSH Hardening**: The cookbook disables root login and password authentication. Use Ansible's `lineinfile` module or the `ssh` module to configure these settings.
- **SSL Certificate Management**: Self-signed certificates are generated for development. Consider using Ansible's `openssl_*` modules or certbot for Let's Encrypt integration.
- **Vault/secrets management**:
  - Redis password is hardcoded in the cache cookbook (`redis_secure_password_123`)
  - PostgreSQL database credentials are hardcoded in the fastapi-tutorial cookbook (`fastapi:fastapi_password`)
  - These should be migrated to Ansible Vault

### Technical Challenges

- **Multi-site Nginx Configuration**: The Chef cookbook dynamically creates site configurations based on node attributes. Ansible templates will need to replicate this functionality.
- **Redis Configuration Hack**: The cache cookbook includes a ruby_block to modify Redis configuration files after they're created. This will need a custom approach in Ansible.
- **Service Dependencies**: The FastAPI application depends on PostgreSQL. Ansible handlers and conditional checks will be needed to ensure proper service ordering.
- **SSL Certificate Generation**: The Chef cookbook generates self-signed certificates. Ansible will need to use the `openssl_*` modules to replicate this functionality.

### Migration Order

1. **nginx-multisite** (Priority 1): Core infrastructure component that other services depend on
2. **cache** (Priority 2): Supporting services that the application may depend on
3. **fastapi-tutorial** (Priority 3): Application layer that depends on the infrastructure components

### Assumptions

1. The target environment will continue to be Fedora 42 or a compatible Linux distribution.
2. Self-signed certificates are acceptable for development purposes.
3. The same directory structure for web content and configuration files will be maintained.
4. The FastAPI application repository at https://github.com/dibanez/fastapi_tutorial.git will remain available.
5. The current security settings (fail2ban, ufw, SSH hardening) are appropriate for the target environment.
6. The PostgreSQL database schema is managed by the FastAPI application and doesn't require additional migration steps.
7. The current Redis and Memcached configurations are sufficient for the application's needs.