# MIGRATION FROM CHEF TO ANSIBLE

## Executive Summary

This repository contains a Chef-based infrastructure setup for a multi-site Nginx web server with caching services (Redis and Memcached) and a FastAPI application backed by PostgreSQL. The migration to Ansible will involve converting three primary cookbooks with their dependencies to equivalent Ansible roles and playbooks.

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
    - Key Features: Git repository deployment, Python virtual environment setup, PostgreSQL database creation, systemd service configuration

### Infrastructure Files

- `Berksfile`: Dependency management for Chef cookbooks - will be replaced by Ansible Galaxy requirements.yml
- `Policyfile.rb`: Chef policy definition - will be replaced by Ansible playbook structure
- `solo.json`: Chef node configuration - will be converted to Ansible inventory variables
- `solo.rb`: Chef configuration file - no direct Ansible equivalent needed
- `Vagrantfile`: VM configuration for development - can be adapted for Ansible testing
- `vagrant-provision.sh`: Provisioning script - will be replaced by Ansible playbook

### Target Details

Based on the source configuration files:

- **Operating System**: Supports both Ubuntu (>= 18.04) and CentOS (>= 7.0), with Fedora 42 used in Vagrant development environment
- **Virtual Machine Technology**: Libvirt (based on Vagrantfile configuration)
- **Cloud Platform**: Not specified, appears to be targeting on-premises or generic VM deployment

## Migration Approach

### Key Dependencies to Address

- **nginx (~> 12.0)**: Replace with Ansible community.nginx collection or geerlingguy.nginx role
- **memcached (~> 6.0)**: Replace with geerlingguy.memcached role
- **redisio (~> 7.2.4)**: Replace with geerlingguy.redis role
- **ssl_certificate (~> 2.1)**: Replace with Ansible's openssl_* modules for certificate management

### Security Considerations

- **Firewall (UFW)**: Migrate to Ansible's community.general.ufw module
- **Fail2ban**: Use community.general.fail2ban_jail module for equivalent configuration
- **SSH Hardening**: Use ansible.posix.sshd_config module to manage SSH configuration
- **SSL Certificates**: Use ansible.builtin.openssl_* modules for certificate generation
- **Redis Authentication**: Ensure password is stored in Ansible Vault
- **PostgreSQL Credentials**: Store database credentials in Ansible Vault

### Technical Challenges

- **Multi-site Nginx Configuration**: Requires careful templating in Ansible to maintain the same flexibility
- **Self-signed SSL Certificates**: Need to ensure proper certificate generation and permissions in Ansible
- **Redis Configuration Hacks**: The Chef cookbook includes a hack to fix Redis configuration that will need special handling
- **Service Orchestration**: Ensuring proper service restart notifications when configurations change

### Migration Order

1. **nginx-multisite** (moderate complexity, foundation for other services)
   - Create base Nginx role
   - Implement SSL certificate generation
   - Configure virtual hosts
   - Implement security hardening

2. **cache** (low complexity, standalone service)
   - Implement Memcached configuration
   - Implement Redis with authentication

3. **fastapi-tutorial** (high complexity, depends on PostgreSQL)
   - Implement PostgreSQL database setup
   - Configure Python environment
   - Deploy application from Git
   - Set up systemd service

### Assumptions

1. The target environment will continue to be Linux-based (Ubuntu/CentOS/Fedora)
2. Self-signed certificates are acceptable for development (production would likely use Let's Encrypt or other CA)
3. The current security configurations are appropriate and should be maintained
4. The FastAPI application repository will remain available at the specified URL
5. The Redis password and PostgreSQL credentials in the Chef code are development values and will be replaced with secure values in production
6. The Nginx sites configuration in solo.json represents the expected production configuration
7. No custom modules or plugins are required beyond what's visible in the Chef code

## Implementation Details

### Ansible Structure

```
ansible/
├── inventory/
│   ├── group_vars/
│   │   ├── all.yml
│   │   └── webservers.yml
│   └── hosts.yml
├── roles/
│   ├── nginx_multisite/
│   ├── cache/
│   └── fastapi_app/
├── playbooks/
│   ├── site.yml
│   ├── nginx.yml
│   ├── cache.yml
│   └── fastapi.yml
└── requirements.yml
```

### Key Variable Migration

The following variables from solo.json will need to be migrated to Ansible inventory:

```yaml
# group_vars/webservers.yml
nginx:
  sites:
    test.cluster.local:
      document_root: /var/www/test.cluster.local
      ssl_enabled: true
    ci.cluster.local:
      document_root: /var/www/ci.cluster.local
      ssl_enabled: true
    status.cluster.local:
      document_root: /var/www/status.cluster.local
      ssl_enabled: true
  ssl:
    certificate_path: /etc/ssl/certs
    private_key_path: /etc/ssl/private

security:
  fail2ban:
    enabled: true
  ufw:
    enabled: true
  ssh:
    disable_root: true
    password_auth: false
```

### Secrets Management

Sensitive information should be stored in Ansible Vault:

```yaml
# vault.yml (encrypted)
redis_password: redis_secure_password_123
postgres_user: fastapi
postgres_password: fastapi_password
postgres_db: fastapi_db
```

## Testing Strategy

1. Develop Ansible roles with molecule for unit testing
2. Create a Vagrant-based test environment similar to the current setup
3. Implement integration tests to verify all components work together
4. Compare outputs and configurations between Chef and Ansible implementations