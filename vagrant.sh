# OMNIBUS_URL="https://www.opscode.com/chef/install.sh"
OMNIBUS_URL="https://omnitruck.chef.io/install.sh"

vagrant ssh-config --host mujin > ./mujin_sshconfig
#ssh -F ./mujin_sshconfig mujin
#berks vendor vendor/cookbooks
if ! vagrant ssh -c 'dpkg -L chef' >/dev/null; then
  knife solo prepare -F ./mujin_sshconfig mujin --omnibus-url "${OMNIBUS_URL}"
fi
knife solo cook -F ./mujin_sshconfig mujin
