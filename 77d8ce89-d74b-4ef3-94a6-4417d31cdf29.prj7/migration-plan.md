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

- `Berksfile`: Dependency management file for Chef cookbooks, lists both local and external dependencies
- `Policyfile.rb`: Chef policy file defining the run list and cookbook dependencies
- `solo.rb`: Chef Solo configuration file specifying cookbook paths and log settings
- `solo.json`: Node attributes and run list for Chef Solo
- `Vagrantfile`: Defines a Fedora 42 VM for testing with port forwarding and networking
- `vagrant-provision.sh`: Shell script for provisioning the Vagrant VM with Chef

### Target Details

Based on the source configuration files:

- **Operating System**: Supports both Ubuntu (>= 18.04) and CentOS (>= 7.0), with Fedora 42 used in Vagrant for testing
- **Virtual Machine Technology**: Vagrant with libvirt provider
- **Cloud Platform**: Not specified, appears to be designed for on-premises or generic cloud VMs

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible nginx role or community.general.nginx_* modules
- **memcached (~> 6.0)**: Replace with Ansible memcached role or package installation tasks
- **redisio (~> 7.2.4)**: Replace with Ansible redis role or package installation tasks
- **ssl_certificate (~> 2.1)**: Replace with Ansible openssl_* modules for certificate management

### Security Considerations

- **SSL Certificate Management**: Migration must handle self-signed certificate generation for development environments
- **Firewall Configuration**: UFW rules need to be migrated to equivalent Ansible ufw module tasks
- **Fail2ban Setup**: Configuration needs to be migrated to Ansible tasks
- **SSH Hardening**: SSH security configurations (disable root login, password authentication) need to be preserved
- **Redis Authentication**: Redis password must be securely managed in Ansible Vault

### Technical Challenges

- **Multi-site Configuration**: The dynamic generation of multiple Nginx site configurations needs careful translation to Ansible templates
- **SSL Certificate Management**: Self-signed certificate generation logic needs to be replicated in Ansible
- **Security Hardening**: Comprehensive security measures need to be maintained across the migration
- **Service Dependencies**: Proper ordering of service installations and configurations must be maintained

### Migration Order

1. **nginx-multisite cookbook** (moderate complexity, foundation for other services)
   - Start with basic Nginx installation and configuration
   - Add SSL certificate generation
   - Implement multi-site configuration
   - Add security hardening features

2. **cache cookbook** (low complexity, standalone service)
   - Implement Memcached configuration
   - Implement Redis with authentication

3. **fastapi-tutorial cookbook** (high complexity, application deployment)
   - Set up PostgreSQL database
   - Deploy FastAPI application
   - Configure systemd service

### Assumptions

1. The target environment will continue to support both Ubuntu and CentOS/RHEL-based systems
2. Self-signed certificates are acceptable for development environments
3. The same security hardening measures are required in the Ansible implementation
4. The FastAPI application source will continue to be pulled from the same Git repository
5. Redis authentication will use the same password mechanism
6. The Nginx site configurations will remain largely the same

## Ansible Structure Recommendation

```
ansible-nginx-multisite/
├── inventories/
│   ├── development/
│   │   ├── group_vars/
│   │   │   └── all.yml  # Development environment variables
│   │   └── hosts        # Development inventory
│   └── production/
│       ├── group_vars/
│       │   └── all.yml  # Production environment variables
│       └── hosts        # Production inventory
├── roles/
│   ├── nginx-multisite/
│   │   ├── defaults/
│   │   │   └── main.yml  # Default variables (from Chef attributes)
│   │   ├── files/
│   │   │   └── (static files)
│   │   ├── handlers/
│   │   │   └── main.yml  # Service restart handlers
│   │   ├── tasks/
│   │   │   ├── main.yml
│   │   │   ├── nginx.yml
│   │   │   ├── security.yml
│   │   │   ├── sites.yml
│   │   │   └── ssl.yml
│   │   ├── templates/
│   │   │   ├── nginx.conf.j2
│   │   │   ├── security.conf.j2
│   │   │   └── site.conf.j2
│   │   └── vars/
│   │       └── main.yml
│   ├── cache/
│   │   ├── defaults/
│   │   │   └── main.yml
│   │   ├── tasks/
│   │   │   ├── main.yml
│   │   │   ├── memcached.yml
│   │   │   └── redis.yml
│   │   ├── templates/
│   │   │   └── redis.conf.j2
│   │   └── handlers/
│   │       └── main.yml
│   └── fastapi-tutorial/
│       ├── defaults/
│       │   └── main.yml
│       ├── tasks/
│       │   ├── main.yml
│       │   ├── app.yml
│       │   └── database.yml
│       ├── templates/
│       │   ├── fastapi.service.j2
│       │   └── env.j2
│       └── handlers/
│           └── main.yml
├── playbooks/
│   ├── site.yml        # Main playbook
│   ├── nginx.yml       # Nginx-specific playbook
│   ├── cache.yml       # Cache services playbook
│   └── fastapi.yml     # FastAPI application playbook
├── group_vars/
│   └── all.yml         # Common variables
├── host_vars/
│   └── (host-specific variables)
├── ansible.cfg        # Ansible configuration
└── Vagrantfile        # For testing
```

## Security and Secrets Management

For the migration, we recommend:

1. Using Ansible Vault for sensitive information:
   - Redis password
   - PostgreSQL credentials
   - Any other secrets currently hardcoded

2. Implementing proper variable precedence:
   - Default role variables for common settings
   - Group variables for environment-specific settings
   - Host variables for host-specific overrides

3. Maintaining the same security hardening measures:
   - UFW firewall rules
   - Fail2ban configuration
   - SSH hardening
   - SSL certificate management

## Testing Strategy

1. Create a parallel Ansible implementation while keeping the Chef code
2. Use the same Vagrant setup to test the Ansible implementation
3. Compare the results of both implementations to ensure feature parity
4. Gradually phase out Chef components as Ansible equivalents are verified

## Timeline Estimate

- **Week 1**: Setup Ansible structure and migrate nginx-multisite cookbook
- **Week 2**: Migrate cache cookbook and implement security features
- **Week 3**: Migrate fastapi-tutorial cookbook and database configuration
- **Week 4**: Testing, documentation, and knowledge transfer