# MIGRATION FROM CHEF TO ANSIBLE

## Executive Summary

This repository contains a Chef-based infrastructure setup for a multi-site Nginx web server with caching services (Redis and Memcached) and a FastAPI application backed by PostgreSQL. The migration to Ansible will involve converting three Chef cookbooks, handling external dependencies, and preserving security configurations. Based on the complexity and scope, this migration is estimated to take 2-3 weeks with 1-2 engineers.

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

- `Berksfile`: Dependency management file for Chef cookbooks - will be replaced by Ansible requirements.yml
- `Policyfile.rb`: Chef policy file defining the run list and cookbook versions - will be replaced by Ansible playbook structure
- `solo.json`: Chef node attributes and run list - will be migrated to Ansible inventory variables
- `solo.rb`: Chef configuration file - will be replaced by ansible.cfg
- `Vagrantfile`: VM configuration for development/testing - can be preserved with modifications to use Ansible provisioner
- `vagrant-provision.sh`: Shell script for Chef provisioning in Vagrant - will be replaced with Ansible provisioning

### Target Details

Based on the source configuration files:

- **Operating System**: Fedora 42 (primary) with support for Ubuntu 18.04+ and CentOS 7+ based on cookbook metadata
- **Virtual Machine Technology**: Vagrant with libvirt provider
- **Cloud Platform**: Not specified, appears to be targeting on-premises or generic VM deployment

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible nginx role (e.g., geerlingguy.nginx)
- **memcached (~> 6.0)**: Replace with Ansible memcached role (e.g., geerlingguy.memcached)
- **redisio (~> 7.2.4)**: Replace with Ansible redis role (e.g., geerlingguy.redis)
- **ssl_certificate (~> 2.1)**: Replace with Ansible certificate management modules (openssl_certificate, openssl_privatekey)

### Security Considerations

- **SSL Certificate Management**: Migration must preserve the self-signed certificate generation for development environments
- **Firewall Configuration (ufw)**: Convert ufw rules to Ansible firewall module configurations
- **fail2ban Setup**: Migrate fail2ban configuration to Ansible
- **SSH Hardening**: Preserve SSH security configurations (disable root login, password authentication)
- **Redis Authentication**: Ensure Redis password is securely managed in Ansible Vault
- **PostgreSQL Credentials**: Store database credentials in Ansible Vault

### Technical Challenges

- **Multi-site Nginx Configuration**: The dynamic generation of multiple virtual hosts with SSL needs careful translation to Ansible templates
- **Service Orchestration**: Ensuring proper service restart notifications when configurations change
- **Python Environment Management**: Properly handling Python virtual environments and dependencies
- **Database Initialization**: Converting PostgreSQL database and user creation to idempotent Ansible tasks

### Migration Order

1. **Infrastructure Setup** (low risk, foundation): Basic VM provisioning, package installation
2. **nginx-multisite** (moderate complexity): Core web server configuration
3. **cache** (moderate complexity): Redis and Memcached services
4. **fastapi-tutorial** (high complexity): Application deployment with database

### Assumptions

- The target environment will continue to be Fedora/RHEL-based systems
- Self-signed certificates are acceptable for development (production would require proper certificate management)
- The same directory structure for web content will be maintained
- The FastAPI application repository will remain available at the specified URL
- PostgreSQL will continue to be the database of choice for the FastAPI application

## Ansible Structure Recommendation

```
ansible-nginx-multisite/
├── ansible.cfg
├── inventory/
│   ├── group_vars/
│   │   ├── all.yml
│   │   └── webservers.yml
│   └── hosts.yml
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
├── requirements.yml
└── Vagrantfile
```

## Migration Steps

1. **Setup Ansible Project Structure**
   - Create directory structure as outlined above
   - Create initial ansible.cfg and inventory files

2. **Create requirements.yml**
   - Add external role dependencies (nginx, redis, memcached)

3. **Migrate Variables**
   - Convert Chef attributes to Ansible variables
   - Move sensitive data to Ansible Vault

4. **Create Role: nginx-multisite**
   - Implement tasks for Nginx installation and configuration
   - Create templates for virtual hosts and SSL configuration
   - Implement security hardening tasks

5. **Create Role: cache**
   - Implement Redis configuration with authentication
   - Implement Memcached configuration

6. **Create Role: fastapi-tutorial**
   - Implement Python environment setup
   - Implement PostgreSQL database creation
   - Implement application deployment and service configuration

7. **Create Playbooks**
   - Develop main site.yml playbook
   - Create individual service playbooks

8. **Update Vagrantfile**
   - Modify to use Ansible provisioner instead of Chef

9. **Testing**
   - Test each role individually
   - Test complete deployment

10. **Documentation**
    - Document new Ansible structure
    - Create usage instructions