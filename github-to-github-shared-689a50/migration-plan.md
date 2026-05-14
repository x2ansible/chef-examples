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
- Security configurations need careful migration
- Credential management needs improvement in the Ansible implementation

## Module Migration Plan

This repository contains Chef cookbooks that need individual migration planning:

### MODULE INVENTORY

- **nginx-multisite**:
    - Description: Nginx web server with multiple SSL-enabled virtual hosts, security hardening, and site configurations
    - Path: cookbooks/nginx-multisite
    - Technology: Chef
    - Key Features: Multi-site configuration, SSL certificate generation, security hardening (fail2ban, ufw firewall), sysctl security settings

- **cache**:
    - Description: Caching services configuration including Memcached and Redis with authentication
    - Path: cookbooks/cache
    - Technology: Chef
    - Key Features: Redis with password authentication, Memcached configuration, dependency on community cookbooks

- **fastapi-tutorial**:
    - Description: Python FastAPI application deployment with PostgreSQL database backend
    - Path: cookbooks/fastapi-tutorial
    - Technology: Chef
    - Key Features: Git-based deployment, Python virtual environment setup, PostgreSQL database provisioning, systemd service configuration

### Infrastructure Files

- `Berksfile`: Dependency management for Chef cookbooks, lists both local and external dependencies
- `solo.json`: Chef Solo configuration with run list and node attributes
- `solo.rb`: Chef Solo configuration file with cookbook paths and log settings
- `vagrant-provision.sh`: Bash script for provisioning the Vagrant VM with Chef
- `Vagrantfile`: Vagrant configuration for development environment using Fedora 42

### Target Details

- **Operating System**: Fedora 42 (based on Vagrantfile configuration)
- **Virtual Machine Technology**: Vagrant with libvirt provider
- **Cloud Platform**: Not specified, appears to be designed for local development/testing

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible Galaxy nginx role or direct package installation and configuration
- **memcached (~> 6.0)**: Replace with Ansible Galaxy memcached role or direct package installation and configuration
- **redisio (~> 7.2.4)**: Replace with Ansible Galaxy redis role or direct package installation and configuration

### Security Considerations

- **SSL Certificate Management**: 
  - Current implementation generates self-signed certificates
  - Migration approach: Use Ansible's openssl_* modules for certificate generation or consider integrating with Let's Encrypt via certbot

- **Firewall Configuration**: 
  - Current implementation uses UFW
  - Migration approach: Use Ansible's ufw module or firewalld module (more appropriate for Fedora)

- **Fail2ban Configuration**: 
  - Current implementation installs and configures fail2ban
  - Migration approach: Use Ansible's template module to configure fail2ban

- **SSH Hardening**: 
  - Current implementation disables root login and password authentication
  - Migration approach: Use Ansible's lineinfile or template module to configure SSH

- **Vault/secrets management**:
  - Redis password is hardcoded in the recipe
  - PostgreSQL credentials are hardcoded in the recipe
  - Migration approach: Use Ansible Vault to securely store and manage credentials

### Technical Challenges

- **Multi-site Nginx Configuration**: 
  - Challenge: Preserving the dynamic generation of site configurations
  - Mitigation: Use Ansible's with_items/loop constructs with templates to generate site configurations

- **Redis Configuration Workaround**: 
  - Challenge: The current implementation includes a hack to fix Redis configuration
  - Mitigation: Create proper Redis configuration templates in Ansible without requiring post-configuration fixes

- **Service Orchestration**: 
  - Challenge: Ensuring proper service restart only when needed
  - Mitigation: Use Ansible's handlers and notify mechanism to restart services only when configuration changes

- **Python Environment Management**: 
  - Challenge: Setting up Python virtual environment and dependencies
  - Mitigation: Use Ansible's pip module with virtualenv parameter

### Migration Order

1. **nginx-multisite** (Priority 1)
   - Core infrastructure component that other services depend on
   - Contains security configurations that should be established first

2. **cache** (Priority 2)
   - Supporting services that the application will use
   - Moderate complexity with external dependencies

3. **fastapi-tutorial** (Priority 3)
   - Application deployment that depends on both nginx and database
   - Higher complexity with database setup and application configuration

### Assumptions

1. The target environment will continue to be Fedora-based systems (the current Vagrantfile specifies Fedora 42)
2. Self-signed certificates are acceptable for development/testing (production would likely need proper certificates)
3. The current security settings (fail2ban, ufw, SSH hardening) are appropriate for the target environment
4. The FastAPI application repository at https://github.com/dibanez/fastapi_tutorial.git will remain available
5. The current Redis and PostgreSQL passwords are for development only and will be replaced with secure passwords in production
6. The Nginx sites configuration in solo.json overrides the default attributes in the cookbook
7. The current implementation doesn't include backup or monitoring solutions
8. No CI/CD pipeline integration is currently implemented