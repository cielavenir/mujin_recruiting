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

- This version installs pybind11 python binding.

|Debian/Ubuntu (MUJIN\_RECRUITING= value)|provisioning|
|:--|:--|
|stretch|./vagrant.sh with stretchenabler|
|buster|./vagrant.sh with stretchenabler|
|bullseye|./vagrant.sh with stretchenabler|
|xenial|./vagrant.sh|
|bionic|./vagrant.sh|
|focal|./vagrant.sh|
|jammy|./vagrant.sh|

Use vagrant.sh for all versions.

## Python3

We are shipping experimental Python3 build. Only focal/jammy/bullseye support this option.

Use:

```
MUJIN_PYTHON3=1 MUJIN_RECRUITING=bullseye vagrant up # or focal
./vagrant_python3.sh
```

As of 20210416, Python3 support is now beta, not experimental.
