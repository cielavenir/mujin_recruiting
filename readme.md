## mujin\_recruiting

My MUJIN entrance task to make a django app with test and make it jenkins-handleable.

```
sudo dpkg -i vagrant.deb
sudo gem install knife-solo -v 0.6.0
MUJIN_RECRUITING=stretch vagrant up
./vagrant.sh
```

- vagrant needs to be installed from official website as debian apt hosts old version which does not support virtualbox 6.x.
- knife-solo 0.7.0 cannot be installed to stretch host due to Ruby version (needs 2.4 or later).
- knife-solo 0.6.0 has some issues with stretch guest. You can launch knifesolo\_stretchenabler.rb (only once!) to patch knife-solo for workaround.

- Only qtosg UI is available; qtcoin will not be built.
- This version installs pybind11 python binding.

|Debian/Ubuntu (MUJIN\_RECRUITING= value)|provisioning|
|:--|:--|
|stretch|./vagrant.sh with stretchenabler|
|buster|./vagrant.sh with stretchenabler|
|xenial|./vagrant.sh|
|bionic|./vagrant.sh|
|focal|./vagrant.sh|

Use vagrant.sh for all versions.

