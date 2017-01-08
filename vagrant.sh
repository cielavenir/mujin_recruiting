vagrant ssh-config --host mujin > ./mujin_sshconfig
#ssh -F ./mujin_sshconfig mujin
#berks vendor vendor/cookbooks
knife solo prepare -F ./mujin_sshconfig mujin
knife solo cook -F ./mujin_sshconfig mujin
