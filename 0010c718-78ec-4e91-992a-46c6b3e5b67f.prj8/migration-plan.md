# MIGRATION FROM CHEF TO ANSIBLE

## Executive Summary

This repository contains a Chef-based infrastructure setup for a multi-site Nginx web server with caching services (Redis and Memcached) and a FastAPI application backed by PostgreSQL. The migration to Ansible will involve converting three Chef cookbooks, handling external dependencies, and ensuring proper security configurations are maintained.

**Estimated Timeline:**
- Analysis and Planning: 1 week
- Development of Ansible Roles: 3-4 weeks
- Testing and Validation: 2 weeks
- Documentation and Knowledge Transfer: 1 week
- Total: 7-8 weeks

**Complexity Assessment:** Medium to High
- Multiple interconnected services
- Security configurations that need careful migration
- Database and application deployment with specific configurations

## Module Migration Plan

This repository contains Chef cookbooks that need individual migration planning:

### MODULE INVENTORY

- **nginx-multisite**:
    - Description: Configures Nginx with multiple SSL-enabled virtual hosts, security hardening, and site-specific configurations
    - Path: cookbooks/nginx-multisite
    - Technology: Chef
    - Key Features: Multi-site configuration, SSL certificate generation, security hardening (fail2ban, ufw), sysctl security settings

- **cache**:
    - Description: Configures caching services including Memcached and Redis with authentication
    - Path: cookbooks/cache
    - Technology: Chef
    - Key Features: Redis with password authentication, Memcached configuration, log directory management

- **fastapi-tutorial**:
    - Description: Deploys a FastAPI Python application with PostgreSQL database backend
    - Path: cookbooks/fastapi-tutorial
    - Technology: Chef
    - Key Features: Python virtual environment setup, Git repository deployment, PostgreSQL database creation, systemd service configuration

### Infrastructure Files

- `Berksfile`: Dependency management for Chef cookbooks - will be replaced by Ansible Galaxy requirements
- `Policyfile.rb`: Chef policy file defining the run list and cookbook versions - will be replaced by Ansible playbooks
- `solo.json`: Configuration data for Chef Solo - will be replaced by Ansible variables
- `solo.rb`: Chef Solo configuration - will be replaced by Ansible configuration
- `Vagrantfile`: Defines the development VM - can be adapted for Ansible testing
- `vagrant-provision.sh`: Provisioning script for Vagrant - will be replaced by Ansible provisioning

### Target Details

Based on the source configuration files:

- **Operating System**: Supports both Ubuntu (>= 18.04) and CentOS (>= 7.0), with the Vagrantfile using Fedora 42
- **Virtual Machine Technology**: Vagrant with libvirt provider
- **Cloud Platform**: Not specified, appears to be targeting on-premises or generic VM deployment

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible nginx role or collection
- **memcached (~> 6.0)**: Replace with Ansible memcached role
- **redisio (~> 7.2.4)**: Replace with Ansible Redis role
- **ssl_certificate (~> 2.1)**: Replace with Ansible certificate management modules (openssl_*)

### Security Considerations

- **SSL Certificate Management**: 
  - Migration approach: Use Ansible's `openssl_*` modules to generate self-signed certificates
  - Ensure proper permissions are maintained for private keys

- **Firewall Configuration (UFW)**:
  - Migration approach: Use Ansible's `ufw` module to configure firewall rules
  - Maintain the same security posture with default deny and specific allows

- **Fail2ban Configuration**:
  - Migration approach: Use Ansible to install and configure fail2ban
  - Maintain the same jail configurations

- **SSH Hardening**:
  - Migration approach: Use Ansible's `lineinfile` or dedicated SSH role to configure SSH security
  - Maintain settings for root login and password authentication

- **Redis Authentication**:
  - Migration approach: Use Ansible templates to configure Redis with password authentication
  - Ensure password is stored securely in Ansible Vault

### Technical Challenges

- **Multi-site Nginx Configuration**: 
  - Description: The current setup dynamically creates multiple virtual hosts with SSL
  - Mitigation: Use Ansible templates with loops to generate site configurations

- **PostgreSQL User and Database Creation**:
  - Description: The current setup creates PostgreSQL users and databases with specific permissions
  - Mitigation: Use Ansible's PostgreSQL modules for idempotent database management

- **Python Application Deployment**:
  - Description: The current setup clones a Git repository and sets up a Python virtual environment
  - Mitigation: Use Ansible's Git and pip modules to manage application deployment

- **Service Management**:
  - Description: The current setup creates and manages systemd services
  - Mitigation: Use Ansible's systemd module for service management

### Migration Order

1. **nginx-multisite** (moderate complexity, foundation for other services)
   - Begin with basic Nginx installation and configuration
   - Add SSL certificate generation
   - Implement security hardening (fail2ban, ufw)
   - Configure virtual hosts

2. **cache** (low complexity, independent service)
   - Implement Memcached configuration
   - Implement Redis with authentication

3. **fastapi-tutorial** (high complexity, depends on database)
   - Set up PostgreSQL database
   - Deploy FastAPI application
   - Configure systemd service

### Assumptions

1. The target environment will continue to be Fedora/CentOS/Ubuntu Linux systems
2. The same security posture needs to be maintained in the Ansible implementation
3. Self-signed certificates are acceptable for development (production would likely use Let's Encrypt or other CA)
4. The FastAPI application source code will remain available at the specified Git repository
5. Redis and Memcached configurations (ports, memory allocation) should remain the same
6. The Nginx sites configuration in solo.json takes precedence over the attributes/default.rb configuration
7. The current setup is for development/testing as indicated by self-signed certificates and Vagrant usage
8. No specific CI/CD pipeline integration is required based on current repository
9. No specific monitoring or logging solutions are implemented beyond basic service configuration
10. The migration will maintain the same directory structure for web content and application code