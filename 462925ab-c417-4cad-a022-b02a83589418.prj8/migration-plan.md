# MIGRATION FROM CHEF TO ANSIBLE

## Executive Summary

This repository contains a Chef-based infrastructure setup for a multi-site Nginx configuration with caching services (Redis and Memcached) and a FastAPI application backed by PostgreSQL. The migration to Ansible will involve converting three Chef cookbooks with their dependencies to equivalent Ansible roles and playbooks. The estimated timeline for this migration is 3-4 weeks, with moderate complexity due to the security configurations and multi-site SSL setup.

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

- `Berksfile`: Dependency management file for Chef cookbooks, lists external dependencies from Chef Supermarket
- `Policyfile.rb`: Chef policy file defining the run list and cookbook dependencies
- `solo.rb`: Chef Solo configuration file
- `solo.json`: Node attributes and run list for Chef Solo
- `Vagrantfile`: Vagrant configuration for testing the infrastructure on Fedora 42
- `vagrant-provision.sh`: Shell script for provisioning the Vagrant VM with Chef

### Target Details

Based on the source configuration files:

- **Operating System**: Supports both Ubuntu (>= 18.04) and CentOS (>= 7.0), with Fedora 42 used for testing in Vagrant
- **Virtual Machine Technology**: Vagrant with libvirt provider
- **Cloud Platform**: Not specified, appears to be designed for on-premises or generic cloud deployment

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible nginx role or community.general.nginx_* modules
- **memcached (~> 6.0)**: Replace with Ansible memcached role or package installation tasks
- **redisio (~> 7.2.4)**: Replace with Ansible redis role or package installation tasks
- **ssl_certificate (~> 2.1)**: Replace with Ansible's openssl_* modules for certificate management

### Security Considerations

- **SSL Certificate Management**: Migration must handle self-signed certificate generation for development environments
- **Firewall Configuration**: UFW rules need to be migrated to equivalent Ansible UFW module tasks
- **fail2ban Configuration**: Configuration needs to be migrated to Ansible tasks
- **SSH Hardening**: SSH security configurations (disable root login, password authentication) need to be preserved
- **Redis Authentication**: Redis password must be securely managed in Ansible Vault

### Technical Challenges

- **Multi-site Configuration**: The dynamic generation of multiple Nginx site configurations needs careful translation to Ansible templates
- **SSL Certificate Management**: Self-signed certificate generation logic needs to be preserved
- **Security Hardening**: Comprehensive security measures need to be maintained across the migration
- **Service Dependencies**: Ensuring proper service dependencies and ordering in Ansible (e.g., PostgreSQL before FastAPI application)

### Migration Order

1. **nginx-multisite cookbook** (moderate complexity, foundation for other services)
   - Create Ansible role for Nginx installation and configuration
   - Implement SSL certificate generation
   - Configure multi-site setup with templates
   - Implement security hardening (fail2ban, UFW)

2. **cache cookbook** (low complexity)
   - Create Ansible roles for Memcached and Redis
   - Configure Redis authentication
   - Ensure proper service management

3. **fastapi-tutorial cookbook** (moderate complexity)
   - Create Ansible role for Python application deployment
   - Implement PostgreSQL database setup
   - Configure systemd service

### Assumptions

1. The target environment will continue to support both Ubuntu and CentOS/RHEL-based distributions
2. Self-signed certificates are acceptable for development environments
3. The same security hardening measures are required in the Ansible implementation
4. The FastAPI application source will continue to be pulled from the same Git repository
5. Redis authentication will continue to use the same approach (password-based)
6. The Nginx site configurations will remain largely the same
7. The PostgreSQL database configuration for the FastAPI application will remain unchanged

## Implementation Details

### Ansible Structure

```
ansible/
├── inventory/
│   ├── hosts.ini
│   └── group_vars/
│       ├── all.yml
│       └── webservers.yml
├── roles/
│   ├── nginx-multisite/
│   │   ├── defaults/
│   │   ├── handlers/
│   │   ├── tasks/
│   │   └── templates/
│   ├── cache/
│   │   ├── defaults/
│   │   ├── handlers/
│   │   ├── tasks/
│   │   └── templates/
│   └── fastapi-tutorial/
│       ├── defaults/
│       ├── handlers/
│       ├── tasks/
│       └── templates/
├── playbooks/
│   ├── site.yml
│   ├── nginx.yml
│   ├── cache.yml
│   └── fastapi.yml
└── ansible.cfg
```

### Variable Management

Chef node attributes will be converted to Ansible variables in:
- `roles/*/defaults/main.yml` for role-specific defaults
- `inventory/group_vars/all.yml` for global variables
- `inventory/group_vars/webservers.yml` for web server specific variables

### Testing Strategy

1. Create a parallel Ansible setup that can be tested alongside the existing Chef setup
2. Use the same Vagrant environment for testing
3. Implement idempotency tests to ensure configurations can be applied multiple times
4. Compare the resulting configurations between Chef and Ansible to ensure equivalence

### Documentation

Create comprehensive documentation for the Ansible roles, including:
- Role dependencies
- Required variables
- Example playbooks
- Security considerations

## Timeline Estimate

- **Week 1**: Analysis and planning, setup Ansible structure, begin nginx-multisite role
- **Week 2**: Complete nginx-multisite role, begin cache role
- **Week 3**: Complete cache role, begin fastapi-tutorial role
- **Week 4**: Complete fastapi-tutorial role, testing, documentation, and handover

## Team Coordination

- Assign one engineer per role for focused development
- Weekly sync meetings to address cross-role dependencies
- Shared testing environment for integration testing
- Documentation review by all team members