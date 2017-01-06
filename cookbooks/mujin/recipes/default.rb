execute "update apt package" do
  command "echo deb http://ftp.debian.org/debian wheezy-backports main >>/etc/apt/sources.list"
  command "apt-get update"
  command "apt-get upgrade -y"
end
%w{g++ git cmake pkg-config debhelper gettext zlib1g-dev zlib-bin libminizip-dev python-dev python-numpy python-sympy python-scipy libxml2-dev liburiparser-dev libpcrecpp0 libpcre3-dev libgmp-dev libmpfr-dev libassimp-dev libqt4-dev qt4-dev-tools  libavcodec-dev libavformat-dev libswscale-dev libsimage-dev libode-dev libsoqt4-dev libqhull-dev libann-dev libbullet-dev libopenscenegraph-dev libhdf5-serial-dev liblapack-dev libboost-iostreams-dev libboost-regex-dev libboost-filesystem-dev libboost-system-dev libboost-python-dev libboost-thread-dev libboost-date-time-dev libboost-test-dev libmpfi-dev ffmpeg libtinyxml-dev libflann-dev}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes"
  end
end
execute "install collada-dom" do
  command <<-EOS
git clone https://github.com/rdiankov/collada-dom.git
cd collada-dom
cmake .
make
make install
cd ..
  EOS
end
execute "install openrave" do
  command <<-EOS
git clone --branch latest_stable https://github.com/rdiankov/openrave.git
cd openrave
cmake .
make
make install
cd ..
  EOS
end
