# MIGRATION FROM CHEF TO ANSIBLE

## Executive Summary

This repository contains a Chef-based infrastructure for deploying a multi-site Nginx web server with caching services (Redis and Memcached) and a FastAPI application backed by PostgreSQL. The migration to Ansible will involve converting three Chef cookbooks with their dependencies to equivalent Ansible roles and playbooks.

**Estimated Timeline:**
- Analysis and Planning: 1 week
- Development of Ansible Roles: 2-3 weeks
- Testing and Validation: 1-2 weeks
- Documentation and Knowledge Transfer: 1 week
- Total: 5-7 weeks

**Complexity Assessment:** Medium
- The codebase is well-structured with clear separation of concerns
- External dependencies on community cookbooks will need Ansible equivalents
- Security configurations require careful migration to maintain hardening standards

## Module Migration Plan

This repository contains Chef cookbooks that need individual migration planning:

### MODULE INVENTORY

- **nginx-multisite**:
    - Description: Nginx web server with multiple SSL-enabled virtual hosts, security hardening, and custom configurations
    - Path: cookbooks/nginx-multisite
    - Technology: Chef
    - Key Features: Multi-site configuration, SSL certificate generation, security hardening (fail2ban, ufw firewall)

- **cache**:
    - Description: Caching services configuration including Memcached and Redis with authentication
    - Path: cookbooks/cache
    - Technology: Chef
    - Key Features: Redis with password authentication, Memcached configuration, log directory management

- **fastapi-tutorial**:
    - Description: Python FastAPI application deployment with PostgreSQL database backend
    - Path: cookbooks/fastapi-tutorial
    - Technology: Chef
    - Key Features: Python virtual environment setup, Git repository deployment, PostgreSQL database creation, systemd service configuration

### Infrastructure Files

- `Berksfile`: Dependency management for Chef cookbooks - will be replaced by Ansible Galaxy requirements.yml
- `Policyfile.rb`: Chef policy definition - will be replaced by Ansible playbook structure
- `solo.json`: Chef node configuration - will be converted to Ansible inventory variables
- `solo.rb`: Chef configuration file - no direct Ansible equivalent needed
- `Vagrantfile`: VM configuration for development - can be adapted for Ansible testing
- `vagrant-provision.sh`: Provisioning script - will be replaced by Ansible playbook

### Target Details

- **Operating System**: Fedora 42 (based on Vagrantfile configuration)
- **Virtual Machine Technology**: Libvirt (based on Vagrantfile provider configuration)
- **Cloud Platform**: Not specified, appears to be targeting on-premises or local development environments

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible community.general.nginx or builtin nginx module
- **memcached (~> 6.0)**: Replace with Ansible community.general.memcached module
- **redisio (~> 7.2.4)**: Replace with Ansible community.redis collection
- **ssl_certificate (~> 2.1)**: Replace with Ansible community.crypto collection for certificate management

### Security Considerations

- **Firewall (ufw)**: Migrate to Ansible's `ansible.posix.firewalld` or `community.general.ufw` modules
- **fail2ban**: Use Ansible's `community.general.fail2ban` module
- **SSH hardening**: Use Ansible's `ansible.posix.sshd` module for SSH configuration
- **SSL certificates**: Use Ansible's `community.crypto` collection for certificate generation and management
- **Redis password**: Store in Ansible Vault instead of plaintext in recipe
- **PostgreSQL credentials**: Store database credentials in Ansible Vault

### Technical Challenges

- **Multi-site Nginx configuration**: The dynamic generation of multiple virtual hosts will require careful templating in Ansible
- **SSL certificate generation**: Self-signed certificate generation logic needs to be replicated in Ansible
- **Security hardening**: Ensuring all security measures are properly implemented in Ansible equivalents
- **Service dependencies**: Maintaining proper ordering of service deployments (database before application, etc.)
- **Redis configuration**: The custom Redis configuration with the "fix_redis_config" hack will need special attention

### Migration Order

1. **nginx-multisite** (foundation for web services)
   - Start with basic Nginx installation and configuration
   - Add SSL certificate management
   - Implement virtual hosts configuration
   - Add security hardening features

2. **cache** (supporting services)
   - Implement Memcached configuration
   - Implement Redis with authentication
   - Ensure proper service management

3. **fastapi-tutorial** (application layer)
   - Set up PostgreSQL database
   - Deploy Python application
   - Configure systemd service
   - Establish connections to cache services

### Assumptions

1. The target environment will continue to be Fedora-based systems
2. Self-signed certificates are acceptable for development environments
3. The same security hardening requirements will apply in the new environment
4. The FastAPI application repository will remain available at the specified URL
5. The multi-site configuration pattern will be maintained
6. Redis and Memcached will continue to be the caching solutions
7. PostgreSQL will remain the database of choice for the FastAPI application

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
│   │   │   ├── main.yml
│   │   │   ├── install.yml
│   │   │   ├── ssl.yml
│   │   │   ├── sites.yml
│   │   │   └── security.yml
│   │   └── templates/
│   ├── cache_services/
│   │   ├── defaults/
│   │   ├── handlers/
│   │   ├── tasks/
│   │   │   ├── main.yml
│   │   │   ├── memcached.yml
│   │   │   └── redis.yml
│   │   └── templates/
│   └── fastapi_app/
│       ├── defaults/
│       ├── handlers/
│       ├── tasks/
│       │   ├── main.yml
│       │   ├── python.yml
│       │   ├── postgresql.yml
│       │   └── app_deploy.yml
│       └── templates/
├── playbooks/
│   ├── site.yml
│   ├── nginx.yml
│   ├── cache.yml
│   └── fastapi.yml
├── group_vars/
│   └── all/
│       ├── vars.yml
│       └── vault.yml
├── ansible.cfg
└── requirements.yml
```

## Vault Strategy

Create an Ansible Vault to store sensitive information:
- Redis authentication password
- PostgreSQL database credentials
- SSL private keys (if applicable)
- Any API keys or tokens used by the FastAPI application

## Testing Strategy

1. Create a Vagrant-based test environment similar to the current setup
2. Develop individual role tests using Molecule
3. Create integration tests to verify the complete stack works together
4. Implement idempotence tests to ensure playbooks can be run multiple times safely