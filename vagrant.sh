# OMNIBUS_URL="https://www.opscode.com/chef/install.sh"
OMNIBUS_URL="https://omnitruck.chef.io/install.sh"

vagrant ssh-config --host mujin > ./mujin_sshconfig
#uh-oh, Net::SSH (knife-solo dependency) is too old
ssh -F ./mujin_sshconfig mujin 'sudo bash -c "echo PubkeyAcceptedAlgorithms=+ssh-rsa >> /etc/ssh/sshd_config"'
ssh -F ./mujin_sshconfig mujin 'sudo /etc/init.d/ssh restart'

#ssh -F ./mujin_sshconfig mujin
#berks vendor vendor/cookbooks
if ! vagrant ssh -c 'dpkg -L chef' >/dev/null; then
  knife solo prepare -F ./mujin_sshconfig mujin --omnibus-url "${OMNIBUS_URL}"
fi
knife solo cook -F ./mujin_sshconfig mujin
