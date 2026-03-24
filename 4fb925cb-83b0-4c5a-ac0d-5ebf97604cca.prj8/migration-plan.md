# MIGRATION FROM CHEF TO ANSIBLE

## Executive Summary

This repository contains a Chef-based infrastructure setup for a multi-site Nginx configuration with caching services (Redis and Memcached) and a FastAPI application backed by PostgreSQL. The migration to Ansible will involve converting three Chef cookbooks, handling external dependencies, and preserving security configurations. Based on the complexity and scope, this migration is estimated to require 3-4 weeks with 1-2 dedicated engineers.

## Module Migration Plan

This repository contains Chef cookbooks that need individual migration planning:

### MODULE INVENTORY

- **nginx-multisite**:
    - Description: Configures Nginx with multiple SSL-enabled subdomains, security hardening, and site configurations
    - Path: cookbooks/nginx-multisite
    - Technology: Chef
    - Key Features: Multi-site SSL configuration, self-signed certificate generation, security hardening with fail2ban and UFW

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

- `Berksfile`: Dependency management for Chef cookbooks, lists both local and external dependencies
- `Policyfile.rb`: Chef Policyfile defining the run list and cookbook dependencies
- `Vagrantfile`: Defines a Fedora 42 VM for local development and testing
- `vagrant-provision.sh`: Bash script for provisioning the Vagrant VM with Chef
- `solo.json`: Configuration data for Chef Solo, contains site configurations and security settings
- `solo.rb`: Chef Solo configuration file

### Target Details

Based on the source configuration files:

- **Operating System**: Supports Ubuntu 18.04+ and CentOS 7.0+ (based on cookbook metadata), with development using Fedora 42 (from Vagrantfile)
- **Virtual Machine Technology**: Vagrant with libvirt provider
- **Cloud Platform**: Not specified, appears to be designed for on-premises or generic cloud deployment

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible nginx role or community.general.nginx_* modules
- **memcached (~> 6.0)**: Replace with Ansible memcached role or package installation tasks
- **redisio (~> 7.2.4)**: Replace with Ansible redis role or package installation tasks
- **ssl_certificate (~> 2.1)**: Replace with Ansible's openssl_* modules for certificate management

### Security Considerations

- **SSL Certificate Management**: Migration must preserve the self-signed certificate generation for development environments
- **Firewall Configuration**: UFW rules need to be migrated to equivalent Ansible UFW module tasks
- **fail2ban Configuration**: Configuration needs to be migrated to Ansible tasks
- **SSH Hardening**: SSH security configurations (disable root login, password authentication) need to be preserved
- **Redis Authentication**: Redis password must be securely managed in Ansible Vault

### Technical Challenges

- **Multi-site Nginx Configuration**: The dynamic generation of site configurations based on attributes needs careful translation to Ansible templates and variables
- **SSL Certificate Management**: Self-signed certificate generation and management needs to be handled properly
- **Service Dependencies**: Ensuring proper ordering of service installations and configurations (e.g., PostgreSQL before FastAPI application)
- **Security Hardening**: Ensuring all security measures are properly implemented in Ansible

### Migration Order

1. **cache cookbook** (moderate complexity, foundational services)
   - Setup Memcached and Redis services
   - Configure authentication for Redis

2. **nginx-multisite cookbook** (high complexity, core infrastructure)
   - Basic Nginx installation and configuration
   - SSL certificate management
   - Site configuration templates
   - Security hardening (fail2ban, UFW)

3. **fastapi-tutorial cookbook** (moderate complexity, application layer)
   - PostgreSQL database setup
   - Python environment configuration
   - Application deployment
   - Systemd service configuration

### Assumptions

1. The target environment will continue to be Ubuntu/CentOS based systems
2. Self-signed certificates are acceptable for development environments
3. The same security policies should be maintained in the Ansible implementation
4. The FastAPI application source will continue to be pulled from the same Git repository
5. Redis will continue to require password authentication
6. The multi-site configuration pattern will be preserved
7. No changes to the application architecture are required as part of the migration
8. The Vagrant development environment should be preserved but updated to use Ansible

## Implementation Plan

### 1. Setup Ansible Structure (Week 1)

- Create Ansible directory structure with roles for each component
- Set up Ansible inventory for development and production environments
- Create Ansible Vault for secrets management
- Update Vagrantfile to use Ansible provisioner

### 2. Migrate Core Infrastructure (Week 2)

- Implement nginx role with multi-site support
- Implement SSL certificate management
- Implement security hardening (fail2ban, UFW)
- Implement cache services (Redis, Memcached)

### 3. Migrate Application Layer (Week 3)

- Implement PostgreSQL database setup
- Implement FastAPI application deployment
- Configure systemd services
- Test end-to-end functionality

### 4. Testing and Documentation (Week 4)

- Comprehensive testing across supported OS versions
- Documentation of Ansible roles and variables
- Knowledge transfer sessions
- Final cleanup and optimization

## Ansible Structure Recommendation

```
ansible/
├── inventories/
│   ├── development/
│   └── production/
├── group_vars/
│   ├── all/
│   │   ├── vars.yml
│   │   └── vault.yml
│   └── webservers/
├── host_vars/
├── roles/
│   ├── nginx-multisite/
│   ├── cache/
│   ├── fastapi-app/
│   └── security/
├── playbooks/
│   ├── site.yml
│   ├── nginx.yml
│   ├── cache.yml
│   └── fastapi.yml
└── ansible.cfg
```

## Conclusion

This migration will convert a Chef-based infrastructure to Ansible while preserving all functionality and security measures. The modular approach allows for incremental migration and testing. The estimated timeline of 3-4 weeks assumes familiarity with both Chef and Ansible concepts.