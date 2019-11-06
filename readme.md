## mujin\_recruiting

My MUJIN entrance task to make a django app with test and make it jenkins-handleable.

```
sudo dpkg -i vagrant.deb
sudo gem install knife-solo -v 0.6.0
vagrant up
./vagrant.sh
```

specifying MUJIN\_RECRUITING\_UBUNTU=1 in vagrant up will cause to provision Ubuntu xenial instead of Debian jessie.

- vagrant needs to be installed from official website as debian apt hosts old version which does not support virtualbox 6.x.
- knife-solo 0.7.0 cannot be installed to stretch host due to Ruby version (needs 2.4 or later).
- knife-solo 0.6.0 has some issues with stretch guest. You can launch knifesolo_stretchenabler.rb (only once!) for workaround.
