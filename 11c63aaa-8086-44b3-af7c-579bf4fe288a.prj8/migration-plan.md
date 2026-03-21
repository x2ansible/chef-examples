# MIGRATION FROM CHEF TO ANSIBLE

## Executive Summary

This repository contains a Chef-based infrastructure setup for a multi-site Nginx web server with caching services (Redis and Memcached) and a FastAPI application backed by PostgreSQL. The migration to Ansible will involve converting three primary Chef cookbooks with their dependencies to equivalent Ansible roles and playbooks. The estimated timeline for this migration is 3-4 weeks, with complexity rated as moderate due to the interdependencies between services and the need to maintain security configurations.

## Module Migration Plan

This repository contains Chef cookbooks that need individual migration planning:

### MODULE INVENTORY

- **nginx-multisite**:
    - Description: Nginx web server with multiple SSL-enabled virtual hosts, security hardening, and site-specific configurations
    - Path: cookbooks/nginx-multisite
    - Technology: Chef
    - Key Features: Multi-site configuration, SSL certificate management, security hardening (fail2ban, UFW)

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

- `Berksfile`: Dependency management file for Chef cookbooks, lists both local and external dependencies with version constraints
- `Policyfile.rb`: Chef policy file defining the run list and cookbook dependencies
- `solo.json`: Configuration data for Chef Solo, contains site configurations and security settings
- `solo.rb`: Chef Solo configuration file specifying cookbook paths and log settings
- `Vagrantfile`: Defines a Fedora 42 VM for local development and testing
- `vagrant-provision.sh`: Shell script to provision the Vagrant VM with Chef

### Target Details

Based on the source configuration files:

- **Operating System**: Supports both Ubuntu (>= 18.04) and CentOS (>= 7.0), with Fedora 42 used for development
- **Virtual Machine Technology**: Vagrant with libvirt provider
- **Cloud Platform**: Not specified, appears to be designed for on-premises or generic cloud deployment

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible nginx role (e.g., geerlingguy.nginx)
- **ssl_certificate (~> 2.1)**: Replace with Ansible certificate management tasks or community roles
- **memcached (~> 6.0)**: Replace with Ansible memcached role (e.g., geerlingguy.memcached)
- **redisio (~> 7.2.4)**: Replace with Ansible Redis role (e.g., geerlingguy.redis)
- **PostgreSQL**: Replace with Ansible PostgreSQL role (e.g., geerlingguy.postgresql)

### Security Considerations

- **SSL Certificate Management**: Migration must maintain proper certificate paths and permissions
- **Redis Authentication**: Ensure Redis password is securely stored in Ansible Vault
- **Security Hardening**: Maintain fail2ban, UFW firewall, and SSH hardening configurations
- **PostgreSQL Credentials**: Store database credentials in Ansible Vault
- **FastAPI Environment Variables**: Securely manage the .env file with sensitive configuration

### Technical Challenges

- **Multi-site Nginx Configuration**: Ensure the complex multi-site setup with SSL is properly translated to Ansible templates
- **Service Dependencies**: Maintain proper ordering of service installation and configuration (e.g., PostgreSQL before FastAPI)
- **Redis Configuration Customization**: The Chef recipe includes a custom Ruby block to modify Redis configuration, which will need a different approach in Ansible
- **Python Environment Management**: Ensure proper setup of Python virtual environments and dependency installation

### Migration Order

1. **Base Infrastructure Role** (low risk): Convert basic system configuration and security hardening
2. **Nginx Multi-site Role** (moderate complexity): Convert Nginx configuration with virtual hosts and SSL
3. **Cache Services Role** (moderate complexity): Convert Memcached and Redis configurations
4. **FastAPI Application Role** (high complexity): Convert PostgreSQL and FastAPI application deployment

### Assumptions

1. The target environment will continue to support either Ubuntu (>= 18.04) or CentOS (>= 7.0)
2. The same security requirements (fail2ban, UFW, SSH hardening) will be maintained
3. SSL certificates will be managed in a similar way (self-signed for development)
4. The FastAPI application source will continue to be available at the specified Git repository
5. Redis will continue to require password authentication
6. The multi-site configuration (test.cluster.local, ci.cluster.local, status.cluster.local) will remain the same
7. The PostgreSQL database configuration for FastAPI will remain similar

## Ansible Structure Recommendation

```
ansible/
├── inventories/
│   ├── development/
│   │   └── hosts.yml
│   └── production/
│       └── hosts.yml
├── group_vars/
│   ├── all/
│   │   ├── main.yml
│   │   └── vault.yml
│   └── webservers/
│       └── main.yml
├── roles/
│   ├── base/
│   │   └── # Security hardening, common packages
│   ├── nginx_multisite/
│   │   └── # Nginx with multiple sites and SSL
│   ├── cache_services/
│   │   └── # Redis and Memcached configuration
│   └── fastapi_app/
│       └── # FastAPI application with PostgreSQL
├── playbooks/
│   ├── site.yml
│   ├── webserver.yml
│   └── application.yml
└── ansible.cfg
```

## Implementation Timeline

1. **Week 1**: Setup Ansible structure, create base role, and implement security hardening
2. **Week 2**: Implement Nginx multi-site role with SSL and site configurations
3. **Week 3**: Implement cache services role (Redis and Memcached) and FastAPI application role
4. **Week 4**: Testing, documentation, and knowledge transfer

## Testing Strategy

1. Create equivalent Vagrant setup with Ansible provisioning
2. Verify each service is properly configured and running
3. Test SSL certificate generation and virtual host configurations
4. Validate security hardening measures
5. Ensure FastAPI application is properly deployed and connected to PostgreSQL