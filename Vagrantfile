# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
echo Beginning Vagrant provisioning...
date > /etc/vagrant_provisioned_at
SCRIPT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.provision "shell", inline: $script

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  config.vm.synced_folder(
    '.',
    '/vagrant',
    type: 'rsync',
    rsync__exclude: [
      '.git/',
      '.vagrant/',
      'log/*',
      'tmp/'
    ]
  )

  config.vm.provision :shell, path: "config/vagrant/build_dependency_setup.sh"
  config.vm.provision :shell, path: "config/vagrant/couchdb_setup.sh"
  config.vm.provision :shell, path: "config/vagrant/imagemagick_setup.sh"
  config.vm.provision :shell, path: "config/vagrant/git_setup.sh"
  config.vm.provision :shell, path: "config/vagrant/nodejs_setup.sh"
  config.vm.provision :shell, path: "config/vagrant/phantomjs_setup.sh"
  config.vm.provision :shell, path: "config/vagrant/rbenv_setup.sh", privileged: false

  # PostgreSQL Server port forwarding
  config.vm.network :forwarded_port, host: 27017, guest: 27017
end
