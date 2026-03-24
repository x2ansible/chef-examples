# MIGRATION FROM CHEF TO ANSIBLE

## Executive Summary

This repository contains a Chef-based infrastructure setup for a multi-site Nginx web server with caching services (Redis and Memcached) and a FastAPI application backed by PostgreSQL. The migration to Ansible will involve converting three Chef cookbooks with their dependencies to equivalent Ansible roles and playbooks.

**Estimated Timeline:**
- Analysis and Planning: 1 week
- Development of Ansible Roles: 2-3 weeks
- Testing and Validation: 1-2 weeks
- Documentation and Knowledge Transfer: 1 week
- Total: 5-7 weeks

**Complexity Assessment:** Medium
- The repository has well-structured Chef cookbooks with clear responsibilities
- External dependencies on community cookbooks need to be replaced with Ansible Galaxy roles
- Security configurations need careful migration to maintain hardening standards

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
    - Key Features: Redis with password authentication, Memcached configuration

- **fastapi-tutorial**:
    - Description: Python FastAPI application deployment with PostgreSQL database backend
    - Path: cookbooks/fastapi-tutorial
    - Technology: Chef
    - Key Features: Python virtual environment setup, Git repository deployment, PostgreSQL database configuration, systemd service management

### Infrastructure Files

- `Berksfile`: Dependency management file listing cookbook dependencies (nginx, ssl_certificate, memcached, redisio)
- `Policyfile.rb`: Chef Policyfile defining the run list and cookbook dependencies
- `solo.json`: Configuration data for Chef Solo, contains site configurations and security settings
- `solo.rb`: Chef Solo configuration file
- `Vagrantfile`: Defines a Fedora 42 VM for development/testing with port forwarding and resource allocation
- `vagrant-provision.sh`: Shell script to provision the Vagrant VM with Chef

### Target Details

Based on the source configuration files:

- **Operating System**: Supports both Ubuntu (>= 18.04) and CentOS (>= 7.0), with Fedora 42 used for development in Vagrant
- **Virtual Machine Technology**: Vagrant with libvirt provider (based on Vagrantfile configuration)
- **Cloud Platform**: Not specified, appears to be designed for on-premises or generic cloud deployment

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible Galaxy nginx role or direct package installation and configuration
- **ssl_certificate (~> 2.1)**: Replace with Ansible's `openssl_*` modules for certificate management
- **memcached (~> 6.0)**: Replace with Ansible Galaxy memcached role or direct package installation and configuration
- **redisio (~> 7.2.4)**: Replace with Ansible Galaxy redis role or direct package installation and configuration

### Security Considerations

- **SSL Certificate Management**: The current implementation generates self-signed certificates. Migrate to Ansible's `openssl_certificate` module or consider integrating with Let's Encrypt via `community.crypto.acme_certificate`.
- **Firewall Configuration**: The Chef cookbook uses UFW. Migrate to Ansible's `ufw` module or consider using `firewalld` for RHEL-based systems.
- **Fail2ban Configuration**: Migrate fail2ban configuration to Ansible using the `community.general.fail2ban` module.
- **SSH Hardening**: Maintain SSH security settings (disable root login, password authentication) using Ansible's `lineinfile` or template modules.
- **Redis Authentication**: Ensure Redis password is stored securely using Ansible Vault.

### Technical Challenges

- **Multi-site Nginx Configuration**: The dynamic generation of multiple virtual hosts needs careful implementation in Ansible using templates and loops.
- **SSL Certificate Generation**: Self-signed certificate generation logic needs to be replicated in Ansible.
- **Service Dependencies**: Ensure proper ordering of service installations and configurations, particularly for the FastAPI application which depends on PostgreSQL.
- **Idempotency**: Ensure all Ansible tasks are idempotent, especially the database creation tasks in the FastAPI cookbook.

### Migration Order

1. **nginx-multisite** (Priority 1): Core infrastructure component that other services depend on
   - Start with basic Nginx installation and configuration
   - Add SSL certificate generation
   - Implement virtual host configuration
   - Add security hardening features

2. **cache** (Priority 2): Supporting services for the application
   - Implement Memcached configuration
   - Implement Redis with authentication

3. **fastapi-tutorial** (Priority 3): Application deployment
   - PostgreSQL installation and configuration
   - Python environment setup
   - Application deployment
   - Service configuration

### Assumptions

1. The target environment will continue to support both Ubuntu and CentOS/RHEL-based distributions.
2. Self-signed certificates are acceptable for development; production may require integration with a certificate authority.
3. The security requirements (fail2ban, firewall, SSH hardening) will remain the same in the Ansible implementation.
4. The FastAPI application repository at https://github.com/dibanez/fastapi_tutorial.git will remain available.
5. The Redis password "redis_secure_password_123" and PostgreSQL password "fastapi_password" are development credentials that should be replaced with Ansible Vault secured variables in production.
6. The current Vagrant setup for development/testing will be maintained or replaced with an equivalent Ansible-based development environment.