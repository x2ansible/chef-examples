# MIGRATION FROM CHEF TO ANSIBLE

## Executive Summary

This repository contains a Chef-based infrastructure setup for a multi-site Nginx web server with caching services (Redis and Memcached) and a FastAPI application backed by PostgreSQL. The migration to Ansible will involve converting 3 Chef cookbooks with their dependencies to equivalent Ansible roles and playbooks.

**Estimated Timeline:**
- Analysis and Planning: 1 week
- Development of Ansible Roles: 2-3 weeks
- Testing and Validation: 1-2 weeks
- Documentation and Knowledge Transfer: 1 week
- Total: 5-7 weeks

**Complexity Assessment:** Medium
- The Chef cookbooks are well-structured and follow standard patterns
- Security configurations are comprehensive but straightforward
- External dependencies on community cookbooks will need Ansible Galaxy equivalents

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
- `Vagrantfile`: Defines the development VM using Fedora 42, with port forwarding and network configuration
- `vagrant-provision.sh`: Shell script for provisioning the Vagrant VM with Chef

### Target Details

Based on the source configuration files:

- **Operating System**: Supports both Ubuntu (>= 18.04) and CentOS (>= 7.0), with development environment using Fedora 42
- **Virtual Machine Technology**: Vagrant with libvirt provider
- **Cloud Platform**: Not specified, appears to be designed for on-premises or generic cloud VMs

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible's `nginx` role or use the `ansible.builtin.package` module with templates
- **memcached (~> 6.0)**: Use Ansible Galaxy's `geerlingguy.memcached` role or create a custom role
- **redisio (~> 7.2.4)**: Use Ansible Galaxy's `geerlingguy.redis` role or create a custom role
- **ssl_certificate (~> 2.1)**: Use Ansible's `openssl_*` modules for certificate management

### Security Considerations

- **Firewall (UFW)**: Migrate to Ansible's `ufw` module or `firewalld` module depending on target OS
- **fail2ban**: Use Ansible Galaxy's `fail2ban` role or create a custom role with templates
- **SSH hardening**: Use Ansible's `lineinfile` module to modify SSH configuration or a dedicated role like `dev-sec.ssh-hardening`
- **SSL certificates**: Use Ansible's `openssl_*` modules to generate self-signed certificates
- **Redis password**: Store in Ansible Vault and reference in templates
- **PostgreSQL credentials**: Store database credentials in Ansible Vault

### Technical Challenges

- **Multi-site Nginx configuration**: Create Ansible templates for site configurations with proper variable substitution
- **Self-signed SSL certificates**: Implement certificate generation with Ansible's `openssl_*` modules
- **Service dependencies**: Ensure proper ordering of tasks for services that depend on each other (e.g., FastAPI depends on PostgreSQL)
- **Idempotency**: Ensure database creation tasks are idempotent to prevent errors on subsequent runs

### Migration Order

1. **nginx-multisite** (moderate complexity, foundation for other services)
   - Create base Nginx role
   - Implement SSL certificate generation
   - Configure multi-site setup
   - Implement security hardening

2. **cache** (low complexity, standalone service)
   - Set up Memcached configuration
   - Configure Redis with authentication

3. **fastapi-tutorial** (high complexity, depends on database)
   - Set up PostgreSQL database
   - Deploy FastAPI application
   - Configure systemd service

### Assumptions

1. The target environment will continue to be Linux-based (Ubuntu/CentOS/Fedora)
2. Self-signed certificates are acceptable for development (production would use proper certificates)
3. The same directory structure for web content will be maintained
4. The FastAPI application source will continue to be pulled from the same Git repository
5. Redis and PostgreSQL passwords in the Chef recipes are placeholders and will be replaced with secure values in Ansible Vault
6. The Vagrant development environment will be maintained but converted to use Ansible provisioner

## Ansible Structure Recommendation

```
ansible-nginx-multisite/
├── inventories/
│   ├── development/
│   │   ├── group_vars/
│   │   │   └── all.yml  # Development-specific variables
│   │   └── hosts        # Development inventory
│   └── production/
│       ├── group_vars/
│       │   └── all.yml  # Production-specific variables
│       └── hosts        # Production inventory
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
│   ├── site.yml         # Main playbook
│   ├── nginx.yml        # Nginx-specific playbook
│   ├── cache.yml        # Cache services playbook
│   └── fastapi.yml      # FastAPI application playbook
├── Vagrantfile          # Updated for Ansible provisioning
└── ansible.cfg          # Ansible configuration
```

## Security and Secrets Management

1. Create an Ansible Vault for storing sensitive information:
   - Redis authentication password
   - PostgreSQL database credentials
   - Any API keys or tokens

2. Reference vault variables in templates and playbooks:
   ```yaml
   # Example vault.yml (encrypted)
   redis_password: secure_redis_password_123
   postgres_password: secure_postgres_password_456
   ```

3. Update the security hardening to use Ansible's built-in modules:
   - Use `ufw` module for firewall configuration
   - Use templates for fail2ban configuration
   - Use `lineinfile` or templates for SSH hardening

## Testing Strategy

1. Develop a testing pipeline using Molecule for role testing
2. Create separate test scenarios for Ubuntu and CentOS targets
3. Implement integration tests to verify:
   - Nginx serves content correctly
   - SSL certificates are properly generated
   - Redis and Memcached are accessible
   - FastAPI application responds to requests
   - Security measures are properly applied

## Documentation Requirements

1. README.md with setup instructions
2. Role-specific documentation explaining variables and usage
3. Example inventory and variable files
4. Vagrant setup instructions for development environment