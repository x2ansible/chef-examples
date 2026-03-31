# MIGRATION FROM CHEF TO ANSIBLE

## Executive Summary

This repository contains a Chef-based infrastructure setup for a multi-site Nginx configuration with caching services (Redis and Memcached) and a FastAPI application backed by PostgreSQL. The migration to Ansible will involve converting three primary Chef cookbooks to Ansible roles and playbooks, addressing external dependencies, and ensuring security configurations are properly maintained.

**Estimated Timeline:**
- Analysis and Planning: 1 week
- Development of Ansible roles: 2-3 weeks
- Testing and Validation: 1-2 weeks
- Documentation and Knowledge Transfer: 1 week
- Total: 5-7 weeks

**Complexity Assessment:** Medium
- Well-structured Chef cookbooks with clear dependencies
- Standard infrastructure components (Nginx, Redis, Memcached, PostgreSQL)
- Security configurations that need careful migration

## Module Migration Plan

This repository contains Chef cookbooks that need individual migration planning:

### MODULE INVENTORY

- **nginx-multisite**:
    - Description: Configures Nginx with multiple SSL-enabled subdomains, security hardening, and site configurations
    - Path: cookbooks/nginx-multisite
    - Technology: Chef
    - Key Features: Multi-site configuration, SSL certificate generation, security hardening with fail2ban and UFW

- **cache**:
    - Description: Configures caching services including Memcached and Redis with authentication
    - Path: cookbooks/cache
    - Technology: Chef
    - Key Features: Redis with password authentication, Memcached configuration

- **fastapi-tutorial**:
    - Description: Deploys a FastAPI Python application with PostgreSQL database backend
    - Path: cookbooks/fastapi-tutorial
    - Technology: Chef
    - Key Features: Python virtual environment setup, PostgreSQL database creation, systemd service configuration

### Infrastructure Files

- `Berksfile`: Defines cookbook dependencies (both local and from Chef Supermarket)
- `Policyfile.rb`: Defines the Chef policy with run list and cookbook dependencies
- `solo.rb`: Chef Solo configuration file defining cookbook paths and log settings
- `solo.json`: Node attributes and run list for Chef Solo
- `Vagrantfile`: Defines a Fedora 42 VM for development/testing with port forwarding
- `vagrant-provision.sh`: Shell script for provisioning the Vagrant VM with Chef

### Target Details

Based on the source configuration files:

- **Operating System**: Fedora 42 (primary) with support for Ubuntu 18.04+ and CentOS 7+ (based on cookbook metadata and Vagrantfile)
- **Virtual Machine Technology**: Libvirt (based on Vagrantfile configuration)
- **Cloud Platform**: Not specified, appears to be targeting on-premises or generic cloud VMs

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible's `nginx` role or community.general collection
- **memcached (~> 6.0)**: Replace with Ansible's `memcached` role or community.general collection
- **redisio (~> 7.2.4)**: Replace with Ansible's `redis` role or community.general collection
- **ssl_certificate (~> 2.1)**: Replace with Ansible's `openssl_*` modules for certificate management

### Security Considerations

- **SSL Certificate Management**: Migration must maintain proper certificate generation and permissions
  - Approach: Use Ansible's `openssl_certificate`, `openssl_privatekey` modules with proper file permissions
  
- **Firewall Configuration (UFW)**: Security hardening must be preserved
  - Approach: Use Ansible's `ufw` module to maintain the same firewall rules

- **fail2ban Configuration**: Brute force protection must be maintained
  - Approach: Use Ansible's `template` module to configure fail2ban with the same jail settings

- **SSH Hardening**: SSH security settings must be preserved
  - Approach: Use Ansible's `lineinfile` or `template` module to configure SSH with the same security parameters

- **Redis Authentication**: Password protection must be maintained
  - Approach: Use Ansible's `template` module to configure Redis with password authentication

- **PostgreSQL Security**: Database user permissions must be properly configured
  - Approach: Use Ansible's `postgresql_*` modules to create users with appropriate permissions

### Technical Challenges

- **Multi-site Nginx Configuration**: The dynamic generation of multiple site configurations needs careful translation
  - Mitigation: Use Ansible's loop constructs with templates to generate site configurations

- **SSL Certificate Generation**: Self-signed certificate generation logic needs to be preserved
  - Mitigation: Create a dedicated Ansible role for SSL certificate management

- **Service Dependencies**: Ensuring proper ordering of service installations and configurations
  - Mitigation: Use Ansible's `meta: dependencies` in roles and proper task ordering

- **Idempotency**: Ensuring all operations are idempotent, especially custom commands
  - Mitigation: Use Ansible's `changed_when` and `failed_when` directives to control task status

### Migration Order

1. **nginx-multisite** (Priority 1)
   - Core infrastructure component that other services depend on
   - Contains security configurations that should be established first

2. **cache** (Priority 2)
   - Supporting services that the application will use
   - Moderate complexity with Redis authentication

3. **fastapi-tutorial** (Priority 3)
   - Application deployment that depends on other infrastructure components
   - Involves database setup, application code deployment, and service configuration

### Assumptions

1. The target environment will continue to be Fedora-based (with support for Ubuntu/CentOS)
2. Self-signed certificates are acceptable for development/testing
3. The same security policies should be maintained in the Ansible implementation
4. The FastAPI application source will continue to be pulled from the same Git repository
5. The same Redis password and PostgreSQL credentials will be used (should be replaced with Ansible Vault)
6. The directory structure for web content and application files will remain the same
7. The Vagrant development environment will be maintained but converted to use Ansible provisioner

## Ansible Structure Recommendation

```
ansible-nginx-multisite/
├── inventories/
│   ├── development/
│   │   ├── hosts.yml
│   │   └── group_vars/
│   └── production/
│       ├── hosts.yml
│       └── group_vars/
├── roles/
│   ├── nginx-multisite/
│   ├── cache/
│   └── fastapi-tutorial/
├── playbooks/
│   ├── site.yml
│   ├── nginx.yml
│   ├── cache.yml
│   └── fastapi.yml
├── Vagrantfile
└── ansible.cfg
```

## Security Recommendations

1. Move hardcoded passwords (Redis, PostgreSQL) to Ansible Vault
2. Consider using Let's Encrypt for production SSL certificates
3. Implement more granular firewall rules based on actual service requirements
4. Consider implementing SELinux policies for additional security
5. Add TLS configuration hardening for Nginx (modern cipher suites, protocols)