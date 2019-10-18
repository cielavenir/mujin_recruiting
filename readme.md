## mujin\_recruiting

```
sudo dpkg -i vagrant.deb
sudo gem install knife-solo -v 0.6.0
vagrant up
./vagrant.sh
```

- knife-solo 0.7.0 cannot be installed to stretch due to Ruby version.
- knife-solo 0.6.0 tries to install libopenssl-ruby, which is not available on stretch.
