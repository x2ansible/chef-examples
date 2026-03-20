# Migration Plan: cache

**TLDR**: This cookbook installs and configures a caching infrastructure with both Memcached and Redis services. It sets up one Memcached instance on port 11211 and one Redis instance on port 6379 with password authentication. The Redis configuration includes custom modifications to remove certain replication-related settings.

## Service Type and Instances

**Service Type**: Cache

**Configured Instances**:

- **memcached**: 
  - Location/Path: Default system paths
  - Port: 11211
  - Key Config: 64MB memory, 1024 max connections

- **redis-6379**: 
  - Location/Path: /etc/redis/6379.conf
  - Port: 6379
  - Key Config: Authentication enabled with password 'redis_secure_password_123'

## File Structure

**Recipes:**
```
cookbooks/cache/recipes/default.rb
/workspace/source/migration-dependencies/cookbook_artifacts/memcached-7992788f1a376defb902059063f5295e37d281cb/recipes/default.rb
/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/recipes/default.rb
/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/recipes/_install_prereqs.rb
/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/recipes/install.rb
/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/recipes/ulimit.rb
/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/recipes/disable_os_default.rb
/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/recipes/configure.rb
/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/recipes/enable.rb
```

**Providers:**
```
/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/providers/configure.rb
/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/providers/install.rb
```

**Templates:**
```
/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/templates/default/redis.conf.erb
/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/templates/default/redis.init.erb
/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/templates/default/redis.upstart.conf.erb
/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/templates/default/redis@.service.erb
```

**Attributes:**
```
/workspace/source/migration-dependencies/cookbook_artifacts/memcached-7992788f1a376defb902059063f5295e37d281cb/attributes/default.rb
/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/attributes/default.rb
```

## Module Explanation

The cookbook performs operations in this order:

1. **memcached::default** (`/workspace/source/migration-dependencies/cookbook_artifacts/memcached-7992788f1a376defb902059063f5295e37d281cb/recipes/default.rb`):
   - Uses custom resource: memcached_instance['memcached']
   - Configures Memcached with 64MB memory, port 11211, max connections 1024
   - Resources: memcached_instance (1)

2. **directory creation** (`cookbooks/cache/recipes/default.rb`):
   - Creates Redis log directory: /var/log/redis
   - Sets owner and group to 'redis', mode '0755'
   - Resources: directory (1)

3. **redisio::default** (`/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/recipes/default.rb`):
   - Updates apt repositories
   - Includes redisio::_install_prereqs if not using package install
   - Resources: apt_update (1), build_essential (1), package (multiple)

4. **redisio::_install_prereqs** (`/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/recipes/_install_prereqs.rb`):
   - Installs prerequisite packages for Redis
   - Resources: package (multiple)

5. **redisio::install** (`/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/recipes/install.rb`):
   - Installs Redis either from package or source
   - If using package: installs redis-server package
   - If using source: builds Redis from source
   - Resources: package (1) or redisio_install (1)

6. **redisio::ulimit** (`/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/recipes/ulimit.rb`):
   - Configures ulimit settings for Redis
   - On Debian systems: modifies /etc/pam.d/su and /etc/pam.d/sudo
   - Resources: template (1), cookbook_file (1), user_ulimit (conditional)

7. **redisio::disable_os_default** (`/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/recipes/disable_os_default.rb`):
   - Disables default OS Redis service if present
   - Resources: service (1)

8. **redisio::configure** (`/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/recipes/configure.rb`):
   - Configures Redis instances
   - Uses custom resource: redisio_configure['redis-servers']
   - Sets up service for Redis instance on port 6379
   - Resources: redisio_configure (1), service (1)

9. **ruby_block fix_redis_config** (`cookbooks/cache/recipes/default.rb`):
   - Modifies Redis configuration file at /etc/redis/6379.conf
   - Removes specific replication-related settings:
     - replica-serve-stale-data
     - replica-read-only
     - repl-ping-replica-period
     - client-output-buffer-limit
     - replica-priority
   - Resources: ruby_block (1)

10. **redisio::enable** (`/workspace/source/migration-dependencies/cookbook_artifacts/redisio-cac70a2ec9102cac4f5391358c8565d244f5d4db/recipes/enable.rb`):
    - Enables and starts Redis service
    - Uses appropriate service name based on init system (systemd, upstart, etc.)
    - For the Redis instance on port 6379
    - Resources: service (1)

## Dependencies

**External cookbook dependencies**:
- memcached
- redisio

**System package dependencies**:
- memcached
- redis-server (if using package install)
- build-essential (if building Redis from source)

**Service dependencies**:
- memcached.service
- redis@6379.service (systemd) or redis6379 (other init systems)

## Checks for the Migration

**Files to verify**:
- /etc/redis/6379.conf
- /var/log/redis/
- /var/lib/redis/
- /etc/memcached.conf (or equivalent based on system)

**Service endpoints to check**:
- Ports listening: 11211 (Memcached), 6379 (Redis)
- Unix sockets: None explicitly configured
- Network interfaces: 0.0.0.0 (Memcached), Redis binding depends on configuration

**Templates rendered**:
- Redis configuration template (redis.conf.erb) - rendered once for port 6379
- Redis service template (based on init system) - rendered once

## Pre-flight checks:

```bash
# Memcached checks
systemctl status memcached
ps aux | grep memcached
netstat -tulpn | grep 11211
ss -tlnp | grep memcached
memcached-tool 127.0.0.1:11211 stats
echo "stats" | nc localhost 11211
echo "stats settings" | nc localhost 11211

# Redis checks
systemctl status redis@6379 || service redis6379 status
ps aux | grep redis
netstat -tulpn | grep 6379
ss -tlnp | grep redis

# Redis authentication check
redis-cli -h localhost -p 6379 -a redis_secure_password_123 ping
redis-cli -h localhost -p 6379 -a redis_secure_password_123 info

# Redis configuration check
cat /etc/redis/6379.conf | grep -E 'port|requirepass'
cat /etc/redis/6379.conf | grep -E 'replica-serve-stale-data|replica-read-only|repl-ping-replica-period|client-output-buffer-limit|replica-priority'

# Redis log check
tail -f /var/log/redis/redis_6379.log

# Memory usage
ps aux | grep redis | awk '{print $2}' | xargs -I {} cat /proc/{}/status | grep VmRSS
ps aux | grep memcached | awk '{print $2}' | xargs -I {} cat /proc/{}/status | grep VmRSS

# File permissions
ls -la /var/log/redis/
ls -la /etc/redis/6379.conf
ls -la /var/lib/redis/

# Data directory check
ls -la /var/lib/redis/
df -h /var/lib/redis/
```