#!/bin/sh -e

echo "=== Begin Vagrant Provisioning using 'config/vagrant/couchdb_setup.sh'"

# Edit the following to change the version of CouchDB that is installed
COUCH_VERSION=1.6.1

###########################################################
# Changes below this line are probably not necessary
###########################################################
print_db_usage () {
  echo "Your CouchDB database has been setup and can be accessed on your local machine on the forwarded port (default: 5984)"
  echo "  Host: 127.0.0.1"
  echo "  Port: 5984"
}

export DEBIAN_FRONTEND=noninteractive

COUCHDB_PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$COUCHDB_PROVISIONED_ON" ]
  then
  echo "VM was already provisioned at: $(cat $COUCHDB_PROVISIONED_ON)"
  echo "To run system updates manually login via 'vagrant ssh' and run 'apt-get update && apt-get upgrade'"
  echo ""
  print_db_usage
  exit
fi


# Install the ppa-finding tool
# for 14.04 release
apt-get install -y software-properties-common
# Add the ppa
add-apt-repository -y ppa:couchdb/stable
# update cached list of packages
apt-get -y update
# Remove any existing couchdb binaries
apt-get remove -yf couchdb couchdb-bin couchdb-common
# Note the version number displayed and ensure its what you expect
apt-get install -Vy couchdb

# Tag the provision time:
date > "$COUCHDB_PROVISIONED_ON"

echo "=== End Vagrant Provisioning using 'config/vagrant/couchdb_setup.sh'"
