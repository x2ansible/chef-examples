# MIGRATION FROM CHEF TO ANSIBLE

## Executive Summary

This repository contains a Chef-based infrastructure setup for a multi-site Nginx web server with caching services (Redis and Memcached) and a FastAPI application backed by PostgreSQL. The migration to Ansible will involve converting three Chef cookbooks with their dependencies to equivalent Ansible roles and playbooks.

**Estimated Timeline:**
- Analysis and Planning: 1 week
- Development of Ansible roles: 2-3 weeks
- Testing and Validation: 1-2 weeks
- Documentation and Knowledge Transfer: 1 week
- Total: 5-7 weeks

**Complexity Assessment:** Medium
- The codebase is well-structured with clear separation of concerns
- Moderate number of external dependencies (nginx, memcached, redisio)
- Security configurations that need careful migration
- Database integration requiring proper credential management

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
    - Key Features: Python virtual environment setup, Git repository deployment, PostgreSQL database creation, systemd service configuration

### Infrastructure Files

- `Berksfile`: Dependency management file listing cookbook dependencies (nginx, ssl_certificate, memcached, redisio)
- `Policyfile.rb`: Chef policy file defining the run list and cookbook versions
- `solo.json`: Configuration data for Chef solo, including site configurations and security settings
- `solo.rb`: Chef solo configuration file
- `Vagrantfile`: Defines a Fedora 42 VM for development/testing with port forwarding
- `vagrant-provision.sh`: Shell script to provision the Vagrant VM with Chef

### Target Details

Based on the source configuration files:

- **Operating System**: Supports both Ubuntu (>= 18.04) and CentOS (>= 7.0), with Fedora 42 used for development
- **Virtual Machine Technology**: Vagrant with libvirt provider
- **Cloud Platform**: Not specified, appears to be designed for on-premises deployment

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible nginx role (e.g., geerlingguy.nginx)
- **memcached (~> 6.0)**: Replace with Ansible memcached role (e.g., geerlingguy.memcached)
- **redisio (~> 7.2.4)**: Replace with Ansible redis role (e.g., geerlingguy.redis)
- **ssl_certificate (~> 2.1)**: Replace with Ansible certificate management tasks using openssl module

### Security Considerations

- **SSL Certificate Management**: The current implementation generates self-signed certificates. Migration should maintain this capability while allowing for future integration with Let's Encrypt.
- **Firewall Configuration**: UFW firewall rules need to be migrated to equivalent Ansible ufw module tasks.
- **fail2ban Configuration**: Fail2ban setup needs to be migrated to Ansible tasks.
- **SSH Hardening**: SSH configuration hardening (disabling root login, password authentication) needs to be preserved.
- **Secrets Management**: Redis password is hardcoded in the recipe. Consider using Ansible Vault for secure storage.
- **PostgreSQL Credentials**: Database credentials are hardcoded in the recipe. Should be migrated to Ansible Vault.

### Technical Challenges

- **Multi-site Configuration**: The dynamic generation of Nginx site configurations based on node attributes needs to be replicated using Ansible's templating system.
- **Service Orchestration**: The current setup has interdependent services (Nginx, Redis, Memcached, PostgreSQL, FastAPI). Proper ordering and handlers will be needed in Ansible.
- **SSL Certificate Generation**: Self-signed certificate generation logic needs to be carefully migrated to maintain security.
- **System Tuning**: Security-related sysctl configurations need to be properly migrated.
- **Database Initialization**: PostgreSQL database and user creation needs to be handled idempotently.

### Migration Order

1. **cache role** (low complexity, foundational service)
   - Implement Memcached configuration
   - Implement Redis with authentication

2. **nginx-multisite role** (medium complexity, depends on SSL certificates)
   - Implement base Nginx configuration
   - Implement SSL certificate generation
   - Implement virtual host configuration
   - Implement security hardening (fail2ban, ufw)

3. **fastapi-tutorial role** (high complexity, depends on PostgreSQL)
   - Implement PostgreSQL installation and configuration
   - Implement Python environment setup
   - Implement application deployment
   - Implement systemd service configuration

### Assumptions

1. The target environment will continue to be either Ubuntu (>= 18.04) or CentOS (>= 7.0).
2. Self-signed certificates are acceptable for the migrated solution (no requirement for CA-signed certificates).
3. The Vagrant development environment will be maintained but converted to use Ansible provisioner.
4. The current security configurations (fail2ban, ufw, SSH hardening) are sufficient and should be maintained.
5. The PostgreSQL database will be local to the application server (no separate database server).
6. Redis authentication is required but the current password can be changed during migration.
7. The FastAPI application source will continue to be pulled from the same Git repository.
8. No high availability or clustering requirements exist for any of the services.
9. No monitoring or logging solutions are currently implemented and not required in the migration.