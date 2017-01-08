#execute "add backports source" do
#  command "echo deb http://ftp.debian.org/debian jessie-backports main >>/etc/apt/sources.list"
#end
#execute "add jenkins key" do
#  command "wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -"
#end
#execute "add jenkins source" do
#  command "echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list"
#end
execute "update apt package" do
  command "apt-get update -y"
end
#execute "upgrade apt package" do
#  command "apt-get upgrade -y"
#end
%w{g++ git cmake pkg-config debhelper gettext zlib1g-dev libminizip-dev libxml2-dev liburiparser-dev libpcrecpp0 libpcre3-dev libgmp-dev libmpfr-dev libassimp-dev libqt4-dev qt4-dev-tools  libavcodec-dev libavformat-dev libswscale-dev libsimage-dev libode-dev libsoqt4-dev libqhull-dev libann-dev libbullet-dev libopenscenegraph-dev libhdf5-serial-dev liblapack-dev libboost-iostreams-dev libboost-regex-dev libboost-filesystem-dev libboost-system-dev libboost-python-dev libboost-thread-dev libboost-date-time-dev libboost-test-dev libmpfi-dev ffmpeg libtinyxml-dev libflann-dev sqlite3 libccd-dev liboctomap-dev python-dev python-numpy python-scipy python-django python-pip jenkins}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes"
  end
end
#python-sympy package has installing issue.
execute "install sympy" do
  command <<-EOS
pip install sympy
  EOS
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
execute "install fcl" do
  command <<-EOS
git clone https://github.com/rdiankov/fcl.git
cd fcl
cmake .
make
make install
cd ..
  EOS
end
execute "install openrave" do
  command <<-EOS
git clone https://github.com/rdiankov/openrave.git
cd openrave
cmake .
make
make install
cd ..
  EOS
end
execute "install openrave_sample_app" do
  command <<-EOS
git clone https://github.com/cielavenir/openrave_sample_app.git
cd openrave_sample_app
python manage.py makemigrations openrave
python manage.py migrate
echo "ready for `python manage.py runserver 0.0.0.0:8000`."
cd ..
  EOS
end
