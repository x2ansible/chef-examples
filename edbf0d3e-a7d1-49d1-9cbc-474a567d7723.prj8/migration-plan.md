# MIGRATION FROM CHEF TO ANSIBLE

## Executive Summary

This repository contains a Chef-based infrastructure setup for a multi-site Nginx configuration with caching services (Redis and Memcached) and a FastAPI application backed by PostgreSQL. The migration to Ansible will involve converting three primary Chef cookbooks to Ansible roles and playbooks, addressing external dependencies, and ensuring security configurations are properly maintained.

**Estimated Timeline:** 3-4 weeks
**Complexity:** Medium
**Team Size Recommendation:** 2-3 DevOps engineers

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

- `Berksfile`: Dependency management for Chef cookbooks - will be replaced by Ansible Galaxy requirements.yml
- `Policyfile.rb`: Chef policy definition - will be replaced by Ansible playbooks
- `Vagrantfile`: VM configuration for testing - can be adapted for Ansible testing
- `solo.json`: Chef node attributes - will be converted to Ansible variables
- `solo.rb`: Chef configuration - will be replaced by ansible.cfg
- `vagrant-provision.sh`: Provisioning script - will be replaced by Ansible provisioning

### Target Details

Based on the source configuration files:

- **Operating System**: Supports Ubuntu 18.04+ and CentOS 7+, with Fedora 42 used in Vagrant testing
- **Virtual Machine Technology**: Vagrant with libvirt provider
- **Cloud Platform**: Not specified, appears to be designed for on-premises or generic cloud VMs

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible nginx role or direct package installation
- **memcached (~> 6.0)**: Replace with Ansible memcached role (e.g., geerlingguy.memcached)
- **redisio (~> 7.2.4)**: Replace with Ansible Redis role (e.g., geerlingguy.redis)
- **ssl_certificate (~> 2.1)**: Replace with Ansible's openssl_* modules for certificate management

### Security Considerations

- **SSL Certificate Management**: Migration must maintain proper certificate generation and permissions
- **Firewall Configuration**: UFW rules need to be migrated to Ansible's ufw module
- **fail2ban Configuration**: Configuration needs to be migrated to Ansible tasks
- **SSH Hardening**: SSH security configurations must be preserved
- **Redis Authentication**: Redis password must be securely managed in Ansible Vault
- **PostgreSQL Credentials**: Database credentials should be stored in Ansible Vault

### Technical Challenges

- **Multi-site Configuration**: The dynamic generation of multiple Nginx sites will require careful templating in Ansible
- **SSL Certificate Generation**: Self-signed certificate generation logic needs to be replicated
- **Security Hardening**: Comprehensive security measures need to be maintained
- **Service Dependencies**: Proper ordering of service installations and configurations must be maintained
- **PostgreSQL User/DB Creation**: Idempotent database creation needs to be implemented

### Migration Order

1. **nginx-multisite** (moderate complexity, foundation for other services)
   - Start with basic Nginx installation
   - Add SSL certificate generation
   - Implement security hardening
   - Configure multi-site setup

2. **cache** (low complexity, standalone service)
   - Implement Memcached configuration
   - Implement Redis with authentication

3. **fastapi-tutorial** (high complexity, application deployment)
   - Set up PostgreSQL
   - Configure Python environment
   - Deploy application code
   - Set up systemd service

### Assumptions

1. The target environment will continue to be Linux-based (Ubuntu/CentOS/Fedora)
2. Self-signed certificates are acceptable for development/testing
3. The same security hardening requirements will apply in the new environment
4. The FastAPI application repository will remain available at the same URL
5. The Redis password and PostgreSQL credentials will need to be managed securely
6. The Vagrant testing environment should be preserved for testing the Ansible conversion

## Ansible Structure Recommendation

```
ansible-nginx-multisite/
├── ansible.cfg
├── inventory/
│   ├── hosts
│   └── group_vars/
│       ├── all.yml
│       └── webservers.yml
├── roles/
│   ├── nginx-multisite/
│   ├── cache/
│   └── fastapi-tutorial/
├── playbooks/
│   ├── site.yml
│   ├── nginx.yml
│   ├── cache.yml
│   └── fastapi.yml
├── templates/
├── files/
└── Vagrantfile
```

## Migration Steps

1. **Setup Ansible Project Structure**
   - Create directory structure
   - Set up ansible.cfg and inventory

2. **Convert Chef Attributes to Ansible Variables**
   - Extract node attributes from solo.json and cookbook attributes
   - Create corresponding group_vars and role defaults

3. **Develop Ansible Roles**
   - Create role for each Chef cookbook
   - Convert Chef resources to Ansible tasks
   - Create templates from Chef templates

4. **Implement Security Measures**
   - Set up Ansible Vault for secrets
   - Ensure proper permissions for SSL certificates
   - Maintain security hardening configurations

5. **Testing**
   - Adapt Vagrantfile for Ansible testing
   - Test each role individually
   - Test complete playbook

6. **Documentation**
   - Document new Ansible structure
   - Create usage examples
   - Document variables and customization options

7. **Deployment**
   - Deploy to test environment
   - Validate functionality
   - Deploy to production