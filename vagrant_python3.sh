#!/bin/sh
set -e

HOSTNAME=python3
SSH_CONFIG_NAME=mujin_sshconfig

# OMNIBUS_URL="https://www.opscode.com/chef/install.sh"
OMNIBUS_URL="https://omnitruck.chef.io/install.sh"
DIR=$(dirname $(realpath $0))

vagrant ssh-config --host "${HOSTNAME}" > "${SSH_CONFIG_NAME}"
echo "
require 'net/ssh'
Net::SSH::Config.class_variable_set(:@@default_files, [(File.dirname File.realpath __FILE__) + '/${SSH_CONFIG_NAME}'])
log.level = :debug
log.target_level = :debug
# log.location = 'stdout'
" > "${DIR}/${SSH_CONFIG_NAME}.rb"

#uh-oh, Net::SSH (knife-solo dependency) is too old
#8.8 or later are affected
ssh -F "${DIR}/${SSH_CONFIG_NAME}" "${HOSTNAME}" "sudo bash -c 'if [[ \"\$(ssh -V 2>&1 | cut -d\  -f1 | cut -d_ -f2)\" > \"8.8\" ]]; then echo PubkeyAcceptedAlgorithms=+ssh-rsa >> /etc/ssh/sshd_config; /etc/init.d/ssh restart; fi'"

#ssh -F "${DIR}/${SSH_CONFIG_NAME}" "${HOSTNAME}"
#berks vendor vendor/cookbooks
#if ! vagrant ssh -c 'dpkg -L chef' >/dev/null; then
#  knife solo prepare -F "${DIR}/${SSH_CONFIG_NAME}" "${HOSTNAME}" --omnibus-url "${OMNIBUS_URL}"
#fi
#knife solo cook -F "${DIR}/${SSH_CONFIG_NAME}" "${HOSTNAME}"
chef-run --chef-license accept -c "${DIR}/${SSH_CONFIG_NAME}.rb" "${HOSTNAME}" ${DIR}/cookbooks/${HOSTNAME}/recipes/default.rb
