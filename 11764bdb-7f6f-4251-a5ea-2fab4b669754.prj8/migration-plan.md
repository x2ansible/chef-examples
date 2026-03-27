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
- The codebase is well-structured with clear separation of concerns
- Security configurations are present and need careful migration
- Multiple external dependencies need to be addressed

## Module Migration Plan

This repository contains Chef cookbooks that need individual migration planning:

### MODULE INVENTORY

- **nginx-multisite**:
    - Description: Nginx web server with multiple SSL-enabled virtual hosts, security hardening, and firewall configuration
    - Path: cookbooks/nginx-multisite
    - Technology: Chef
    - Key Features: Multi-site configuration, SSL certificate generation, fail2ban integration, UFW firewall setup

- **cache**:
    - Description: Caching services configuration including Memcached and Redis with authentication
    - Path: cookbooks/cache
    - Technology: Chef
    - Key Features: Redis with password authentication, Memcached configuration

- **fastapi-tutorial**:
    - Description: Python FastAPI application deployment with PostgreSQL database backend
    - Path: cookbooks/fastapi-tutorial
    - Technology: Chef
    - Key Features: Python virtual environment setup, PostgreSQL database creation, systemd service configuration

### Infrastructure Files

- `Berksfile`: Dependency management for Chef cookbooks - will be replaced by Ansible Galaxy requirements.yml
- `Policyfile.rb`: Chef policy definition - will be replaced by Ansible playbook structure
- `solo.rb`: Chef Solo configuration - will be replaced by Ansible configuration
- `solo.json`: Chef node attributes - will be migrated to Ansible group_vars or host_vars
- `Vagrantfile`: Development environment definition - can be adapted for Ansible testing
- `vagrant-provision.sh`: Provisioning script - will be replaced by Ansible provisioning

### Target Details

- **Operating System**: Fedora 42 (based on Vagrantfile), with support for Ubuntu 18.04+ and CentOS 7+ (based on cookbook metadata)
- **Virtual Machine Technology**: Libvirt (based on Vagrantfile configuration)
- **Cloud Platform**: Not specified, appears to be targeting on-premises or generic VM deployment

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible nginx role or direct package installation
- **memcached (~> 6.0)**: Replace with Ansible memcached role or direct package configuration
- **redisio (~> 7.2.4)**: Replace with Ansible redis role or direct package configuration
- **ssl_certificate (~> 2.1)**: Replace with Ansible certificate management tasks

### Security Considerations

- **SSL Certificate Management**: The current implementation generates self-signed certificates. Migrate to Ansible's crypto modules for certificate generation or consider integrating with Let's Encrypt via certbot.
- **Firewall Configuration (UFW)**: Migrate UFW rules to Ansible's ufw module or firewalld for Fedora/RHEL systems.
- **fail2ban Integration**: Configure fail2ban using Ansible's template module and service management.
- **SSH Hardening**: Preserve SSH security settings (disable root login, password authentication) using Ansible's lineinfile or template modules.
- **Redis Authentication**: Ensure Redis password is stored securely using Ansible Vault.
- **PostgreSQL Credentials**: Store database credentials securely using Ansible Vault.

### Technical Challenges

- **Multi-site Nginx Configuration**: The dynamic generation of multiple virtual hosts will require careful templating in Ansible.
- **SSL Certificate Generation**: Self-signed certificate generation logic needs to be replicated or improved in Ansible.
- **System Hardening**: Security configurations across multiple services need to be maintained with proper idempotency.
- **Service Dependencies**: Ensure proper ordering of service deployments (e.g., PostgreSQL before FastAPI application).

### Migration Order

1. **cache cookbook** (Low complexity, foundational service)
   - Implement Memcached configuration
   - Implement Redis with authentication

2. **nginx-multisite cookbook** (Medium complexity, core infrastructure)
   - Implement base Nginx configuration
   - Implement SSL certificate generation
   - Implement security hardening (fail2ban, UFW)
   - Implement multi-site virtual host configuration

3. **fastapi-tutorial cookbook** (Medium complexity, application layer)
   - Implement PostgreSQL database setup
   - Implement Python application deployment
   - Implement systemd service configuration

### Assumptions

1. The target environment will continue to be Fedora/RHEL or Ubuntu/Debian based systems.
2. Self-signed certificates are acceptable for the migrated solution (not production-grade).
3. The current security practices should be maintained or enhanced in the Ansible implementation.
4. The FastAPI application source will continue to be pulled from the same Git repository.
5. The Redis password and PostgreSQL credentials in the Chef code are placeholders and will be replaced with secure values in Ansible Vault.
6. The current directory structure with three separate sites will be maintained.
7. The Vagrant development environment should be preserved for testing the Ansible implementation.