Bringing machine 'default' up with 'libvirt' provider...
==> default: Checking if box 'jtarpley/fedora42_base' version '2026.05.20' is up to date...
==> default: Running provisioner: shell...
    default: Running: /tmp/vagrant-shell20261112-960898-80a00g.sh
    default: 🚀 Starting Chef provisioning in Vagrant VM...
    default: Updating and loading repositories:
    default: Repositories loaded.
    default: Package "git-2.54.0-1.fc42.x86_64" is already installed.
    default: Package "wget2-wget-2.2.1-1.fc42.x86_64" is already installed.
    default: Package "gcc-15.2.1-7.fc42.x86_64" is already installed.
    default: Package "gcc-c++-15.2.1-7.fc42.x86_64" is already installed.
    default: Package "make-1:4.4.1-10.fc42.x86_64" is already installed.
    default: Package "cmake-3.31.11-1.fc42.x86_64" is already installed.
    default: Package "ruby-3.4.8-27.fc42.x86_64" is already installed.
    default: Package "ruby-devel-3.4.8-27.fc42.x86_64" is already installed.
    default: Package "rubygem-ruby-shadow-2.5.1-11.fc42.x86_64" is already installed.
    default: Package "libffi-devel-3.4.6-5.fc42.x86_64" is already installed.
    default: Package "libyaml-devel-0.2.5-16.fc42.x86_64" is already installed.
    default: 
    default: Nothing to do.
    default: Successfully installed chef-bin-18.8.54
    default: 1 gem installed
    default: Successfully installed berkshelf-8.1.23
    default: 1 gem installed
    default: 📚 Downloading cookbook dependencies...
    default: Resolving cookbook dependencies...
    default: Fetching 'cache' from source at cookbooks/cache
    default: Fetching 'fastapi-tutorial' from source at cookbooks/fastapi-tutorial
    default: Fetching 'nginx-multisite' from source at cookbooks/nginx-multisite
    default: Fetching cookbook index from https://supermarket.chef.io...
    default: Unable to satisfy the following requirements:
    default: 
    default: - `cyberark-conjur (~> 3.0)` required by `nginx-multisite-1.0.0`
    default: Unable to find a solution for demands: cache (1.0.0), fastapi-tutorial (1.0.0), memcached (~> 6.0), nginx (~> 12.0), nginx-multisite (1.0.0), redisio (~> 7.2.4)
