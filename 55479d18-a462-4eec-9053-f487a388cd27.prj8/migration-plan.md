# MIGRATION FROM CHEF TO ANSIBLE

## Executive Summary

This repository contains a Chef-based infrastructure setup for a multi-site Nginx web server with caching services (Redis and Memcached) and a FastAPI application backed by PostgreSQL. The migration to Ansible will involve converting three primary Chef cookbooks to Ansible roles and playbooks, addressing external dependencies, and ensuring security configurations are properly maintained.

**Estimated Timeline:**
- Analysis and Planning: 1 week
- Development of Ansible Roles: 2-3 weeks
- Testing and Validation: 1-2 weeks
- Documentation and Knowledge Transfer: 1 week
- Total: 5-7 weeks

**Complexity Assessment:** Medium
- The repository has well-structured Chef cookbooks with clear responsibilities
- Security configurations are present and need careful migration
- External dependencies on community cookbooks need to be replaced with Ansible Galaxy roles or custom implementations

## Module Migration Plan

This repository contains Chef cookbooks that need individual migration planning:

### MODULE INVENTORY

- **nginx-multisite**:
    - Description: Nginx web server with multiple SSL-enabled virtual hosts, security hardening, and site configuration
    - Path: cookbooks/nginx-multisite
    - Technology: Chef
    - Key Features: Multi-site configuration, SSL certificate generation, security hardening (fail2ban, ufw firewall)

- **cache**:
    - Description: Caching services configuration including Memcached and Redis with authentication
    - Path: cookbooks/cache
    - Technology: Chef
    - Key Features: Redis with password authentication, Memcached configuration

- **fastapi-tutorial**:
    - Description: Python FastAPI application deployment with PostgreSQL database backend
    - Path: cookbooks/fastapi-tutorial
    - Technology: Chef
    - Key Features: Python virtual environment setup, Git repository deployment, PostgreSQL database configuration, systemd service management

### Infrastructure Files

- `Berksfile`: Dependency management for Chef cookbooks, lists both local and external dependencies
- `Policyfile.rb`: Chef Policyfile defining the run list and cookbook dependencies
- `solo.json`: Node attributes and run list for Chef Solo, contains configuration for nginx sites and security settings
- `solo.rb`: Chef Solo configuration file
- `Vagrantfile`: Defines a Fedora 42 VM for development/testing with port forwarding and resource allocation
- `vagrant-provision.sh`: Bash script to provision the Vagrant VM with Chef

### Target Details

Based on the source configuration files:

- **Operating System**: Supports both Ubuntu (>= 18.04) and CentOS (>= 7.0) as specified in cookbook metadata files. The Vagrantfile uses Fedora 42 for development.
- **Virtual Machine Technology**: Vagrant with libvirt provider as indicated in the Vagrantfile
- **Cloud Platform**: Not specified, appears to be designed for on-premises or generic cloud VMs

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible's `nginx` module or community.general collection
- **memcached (~> 6.0)**: Replace with Ansible's `memcached` module or dedicated role from Ansible Galaxy
- **redisio (~> 7.2.4)**: Replace with Ansible Redis role from Ansible Galaxy or custom implementation
- **ssl_certificate (~> 2.1)**: Replace with Ansible's `openssl_*` modules for certificate management

### Security Considerations

- **Firewall (UFW)**: Migrate UFW configuration to Ansible's `ufw` module
- **Fail2ban**: Use Ansible's `fail2ban` module or community collection
- **SSH hardening**: Migrate SSH security configurations using Ansible's `lineinfile` or templates
- **SSL certificates**: Ensure secure generation and storage of SSL certificates using Ansible's `openssl_*` modules
- **Redis password**: Store Redis authentication password in Ansible Vault
- **PostgreSQL credentials**: Store database credentials in Ansible Vault

### Technical Challenges

- **Multi-site Nginx configuration**: Ensure the dynamic generation of site configurations is properly implemented in Ansible using templates and loops
- **SSL certificate generation**: Implement proper certificate generation and management in Ansible
- **Service dependencies**: Maintain proper ordering of service installations and configurations
- **Idempotency**: Ensure all operations are idempotent, especially database user creation and schema setup

### Migration Order

1. **nginx-multisite role** (moderate complexity, foundation for web services)
   - Base Nginx installation and configuration
   - Security hardening (fail2ban, ufw, sysctl)
   - SSL certificate generation
   - Virtual host configuration

2. **cache role** (low complexity, independent service)
   - Memcached installation and configuration
   - Redis installation and configuration with authentication

3. **fastapi-tutorial role** (high complexity, depends on database)
   - PostgreSQL installation and configuration
   - Database and user creation
   - Python environment setup
   - Application deployment
   - Systemd service configuration

### Assumptions

1. The target environment will continue to be either Ubuntu (>= 18.04) or CentOS (>= 7.0)
2. The same security requirements will apply in the new Ansible implementation
3. The FastAPI application source code will remain available at the specified Git repository
4. The multi-site configuration pattern will be maintained
5. Self-signed certificates are acceptable for development (production would likely use Let's Encrypt or other CA)
6. The Redis password and PostgreSQL credentials in the Chef recipes are development values and will be replaced with secure values in Ansible Vault

## Ansible Structure Recommendation

```
ansible-nginx-multisite/
├── inventories/
│   ├── development/
│   │   ├── hosts.yml
│   │   └── group_vars/
│   │       ├── all.yml
│   │       └── web_servers.yml
│   └── production/
│       ├── hosts.yml
│       └── group_vars/
│           ├── all.yml
│           └── web_servers.yml
├── roles/
│   ├── nginx_multisite/
│   │   ├── defaults/
│   │   ├── handlers/
│   │   ├── tasks/
│   │   └── templates/
│   ├── cache/
│   │   ├── defaults/
│   │   ├── handlers/
│   │   ├── tasks/
│   │   └── templates/
│   └── fastapi_tutorial/
│       ├── defaults/
│       ├── handlers/
│       ├── tasks/
│       └── templates/
├── playbooks/
│   ├── site.yml
│   ├── nginx.yml
│   ├── cache.yml
│   └── fastapi.yml
├── requirements.yml
└── vagrant.yml
```

## Testing Strategy

1. Develop a Vagrant-based testing environment similar to the existing one
2. Create separate test playbooks for each role
3. Implement molecule tests for individual roles
4. Perform integration testing with all roles combined
5. Validate against the same functionality provided by the original Chef cookbooks

## Knowledge Transfer Plan

1. Document each Ansible role with detailed README files
2. Create a migration guide for Chef users transitioning to the Ansible codebase
3. Provide examples of common tasks and customizations
4. Schedule knowledge sharing sessions with the team