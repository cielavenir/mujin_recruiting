vagrant ssh-config --host mujin > ./mujin_sshconfig
#ssh -F ./mujin_sshconfig mujin
#berks vendor vendor/cookbooks
if ! vagrant ssh -c 'dpkg -L chef' >/dev/null; then
  knife solo prepare -F ./mujin_sshconfig mujin
fi
knife solo cook -F ./mujin_sshconfig mujin
