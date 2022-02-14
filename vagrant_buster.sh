# OMNIBUS_URL="https://www.opscode.com/chef/install.sh"
OMNIBUS_URL="https://omnitruck.chef.io/install.sh"

vagrant ssh-config --host buster > ./buster_sshconfig
#ssh -F ./buster_sshconfig buster
#berks vendor vendor/cookbooks
if ! vagrant ssh -c 'dpkg -L chef' >/dev/null; then
  knife solo prepare -F ./buster_sshconfig buster --omnibus-url "${OMNIBUS_URL}"
fi
knife solo cook -F ./buster_sshconfig buster
