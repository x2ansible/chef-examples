# MIGRATION FROM CHEF TO ANSIBLE

## Executive Summary

This repository contains a Chef-based infrastructure configuration for a multi-site Nginx setup with caching services (Redis and Memcached) and a FastAPI application. The migration to Ansible will involve converting three primary Chef cookbooks, their dependencies, and associated configuration files. The estimated timeline for migration is 3-4 weeks, with moderate complexity due to security configurations and multi-site SSL setup.

## Module Migration Plan

This repository contains Chef cookbooks that need individual migration planning:

### MODULE INVENTORY

- **nginx-multisite**:
    - Description: Nginx web server with multiple SSL-enabled virtual hosts, security hardening, and fail2ban integration
    - Path: cookbooks/nginx-multisite
    - Technology: Chef
    - Key Features: Multi-site SSL configuration, security headers, fail2ban integration, UFW firewall rules, sysctl security settings

- **cache**:
    - Description: Caching services configuration including Memcached and Redis with authentication
    - Path: cookbooks/cache
    - Technology: Chef
    - Key Features: Redis with password authentication, Memcached configuration

- **fastapi-tutorial**:
    - Description: Python FastAPI application deployment with PostgreSQL database
    - Path: cookbooks/fastapi-tutorial
    - Technology: Chef
    - Key Features: Python virtual environment setup, PostgreSQL database creation, systemd service configuration

### Infrastructure Files

- `Berksfile`: Dependency management for Chef cookbooks - will be replaced by Ansible Galaxy requirements
- `Policyfile.rb`: Chef policy file defining the run list and cookbook versions - will be replaced by Ansible playbook structure
- `solo.json`: Chef node attributes configuration - will be migrated to Ansible group_vars or host_vars
- `solo.rb`: Chef configuration file - will be replaced by Ansible configuration
- `Vagrantfile`: Vagrant configuration for development environment - can be adapted for Ansible testing
- `vagrant-provision.sh`: Shell script for provisioning Vagrant VM - will be replaced by Ansible provisioning

### Target Details

- **Operating System**: Fedora 42 (based on Vagrantfile configuration)
- **Virtual Machine Technology**: libvirt (based on Vagrant provider configuration)
- **Cloud Platform**: Not specified, appears to be targeting on-premises or local development environments

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible nginx role or community.general.nginx_* modules
- **memcached (~> 6.0)**: Replace with Ansible memcached role or package installation tasks
- **redisio (~> 7.2.4)**: Replace with Ansible Redis role or package installation tasks
- **ssl_certificate (~> 2.1)**: Replace with Ansible OpenSSL modules for certificate generation

### Security Considerations

- **SSL Configuration**: Migrate SSL certificate generation and configuration using Ansible's crypto modules
  - Self-signed certificates are generated in the current implementation
  - Migration should maintain the same security parameters (TLS versions, cipher suites)

- **fail2ban Integration**: Implement fail2ban configuration using Ansible templates
  - Current implementation has specific jails for SSH, Nginx HTTP auth, request limiting, and bot protection
  - Maintain the same ban times and retry limits

- **Firewall Rules**: Migrate UFW rules to appropriate firewall module
  - Current implementation enables UFW with specific rules for SSH, HTTP, and HTTPS
  - Consider using ansible.posix.firewalld for RHEL-based systems

- **System Hardening**: Migrate sysctl security settings using Ansible sysctl module
  - Current implementation includes IP spoofing protection, ICMP redirect handling, and TCP SYN flood protection
  - Maintain the same security posture

- **SSH Hardening**: Migrate SSH security configurations
  - Current implementation disables root login and password authentication
  - Use ansible.posix.ssh_config module for configuration

### Technical Challenges

- **Multi-site Nginx Configuration**: The current implementation dynamically generates site configurations based on node attributes
  - Challenge: Maintaining the same flexibility with Ansible templates
  - Mitigation: Use Ansible template module with proper variable structures

- **Custom Resource Handling**: The Chef cookbook includes a custom `lineinfile` resource
  - Challenge: Replicating this functionality in Ansible
  - Mitigation: Use Ansible's built-in lineinfile module which provides similar functionality

- **Redis Configuration Hack**: The current implementation includes a Ruby block to fix Redis configuration
  - Challenge: Implementing the same fix in Ansible
  - Mitigation: Use Ansible's lineinfile or replace module with proper regular expressions

- **PostgreSQL User and Database Creation**: The current implementation uses shell commands for database operations
  - Challenge: Converting to idempotent Ansible tasks
  - Mitigation: Use Ansible's postgresql_* modules for proper database management

### Migration Order

1. **Base Infrastructure** (Low complexity)
   - Vagrant configuration
   - Basic system configuration

2. **nginx-multisite Cookbook** (Medium complexity)
   - Nginx installation and base configuration
   - SSL certificate generation
   - Virtual host configuration
   - Security headers and configurations

3. **cache Cookbook** (Medium complexity)
   - Memcached installation and configuration
   - Redis installation and configuration with authentication

4. **Security Configurations** (Medium-high complexity)
   - fail2ban setup
   - Firewall rules
   - sysctl security settings
   - SSH hardening

5. **fastapi-tutorial Cookbook** (High complexity)
   - PostgreSQL installation and configuration
   - Python environment setup
   - Application deployment
   - Systemd service configuration

### Assumptions

1. The target environment will continue to be Fedora-based systems (specifically Fedora 42 as indicated in the Vagrantfile)
2. The same security requirements will apply in the Ansible implementation
3. Self-signed certificates are acceptable for the migrated solution (production would likely use Let's Encrypt or other CA)
4. The FastAPI application source will remain available at the same GitHub repository
5. Redis password ("redis_secure_password_123") will need to be managed securely in Ansible Vault
6. PostgreSQL credentials ("fastapi"/"fastapi_password") will need to be managed securely in Ansible Vault
7. The current implementation does not include monitoring or logging solutions beyond basic Nginx logs
8. The current implementation assumes a single-server deployment model