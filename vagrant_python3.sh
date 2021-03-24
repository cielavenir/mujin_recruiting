vagrant ssh-config --host python3 > ./mujin_sshconfig
#ssh -F ./mujin_sshconfig python3
#berks vendor vendor/cookbooks
if ! vagrant ssh -c 'dpkg -L chef' >/dev/null; then
  knife solo prepare -F ./mujin_sshconfig python3
fi
knife solo cook -F ./mujin_sshconfig python3
