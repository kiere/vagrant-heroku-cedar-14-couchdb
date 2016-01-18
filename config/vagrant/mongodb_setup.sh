#!/bin/sh -e

echo "=== Begin Vagrant Provisioning using 'config/vagrant/mongo_setup.sh'"

# Edit the following to change the version of MongoDB that is installed
MONGO_VERSION=2.6.5

###########################################################
# Changes below this line are probably not necessary
###########################################################
print_db_usage () {
  echo "Your MongoDB database has been setup and can be accessed on your local machine on the forwarded port (default: 27017)"
  echo "  Host: localhost"
  echo "  Port: 27017"
  echo ""
  echo "mongo access to app database user via VM:"
  echo "  vagrant ssh"
  echo "  mongo --host localhost --port 27017 <DATABASE_NAME>"
  echo "  NOTE: if connecting to local host and default port, you don't need --host and --port"
}

export DEBIAN_FRONTEND=noninteractive

MONGO_PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$MONGO_PROVISIONED_ON" ]
  then
  echo "VM was already provisioned at: $(cat $MONGO_PROVISIONED_ON)"
  echo "To run system updates manually login via 'vagrant ssh' and run 'apt-get update && apt-get upgrade'"
  echo ""
  print_db_usage
  exit
fi

MONGO_REPO_APT_SOURCE=/etc/apt/sources.list.d/mongodb.list
if [ ! -f "$MONGO_REPO_APT_SOURCE" ]
  then
  # Add MongoDB apt repo:
  echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > "$MONGO_REPO_APT_SOURCE"

  # Import MongoDB public GPG key
  # sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
fi

# Update package list and upgrade all packages
apt-get update
apt-get -y upgrade

# apt-get install -y mongodb-org # Installs latest version

# Install specific version.  Mongo docs state to include all packages with version number
sudo apt-get install -y mongodb-org=$MONGO_VERSION mongodb-org-server=$MONGO_VERSION mongodb-org-shell=$MONGO_VERSION mongodb-org-mongos=$MONGO_VERSION mongodb-org-tools=$MONGO_VERSION

# Tag the provision time:
date > "$MONGO_PROVISIONED_ON"

echo "=== End Vagrant Provisioning using 'config/vagrant/mongo_setup.sh'"
