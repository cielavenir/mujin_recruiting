#execute "add backports source" do
#  command "echo deb http://ftp.debian.org/debian jessie-backports main >>/etc/apt/sources.list"
#end
#execute "add jenkins key" do
#  command "wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -"
#end
#execute "add jenkins source" do
#  command "echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list"
#end
execute "update apt package part1" do
  command "apt-get update -y"
end
%w{dirmngr}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes"
  end
end
execute "add deb-multimedia source" do
  command <<-EOS
if [[ `cat /etc/issue` = Debian* ]]; then
  apt-key adv --keyserver keyserver.ubuntu.com --recv-key 5C808C2B65558117
  echo deb http://www.deb-multimedia.org jessie main non-free >>/etc/apt/sources.list
fi
  EOS
end
execute "update apt package part2" do
  command "apt-get update -y"
end
#execute "upgrade apt package" do
#  command "apt-get upgrade -y"
#end
%w{g++ gfortran git cmake pkg-config debhelper gettext zlib1g-dev libminizip-dev libxml2-dev liburiparser-dev libpcre3-dev libgmp-dev libmpfr-dev libassimp-dev libqt4-dev qt4-dev-tools libavcodec-dev libavformat-dev libswscale-dev libsimage-dev libode-dev libsoqt4-dev libqhull-dev libann-dev libbullet-dev libopenscenegraph-dev libhdf5-serial-dev liblapack-dev libboost-iostreams-dev libboost-regex-dev libboost-filesystem-dev libboost-system-dev libboost-python-dev libboost-thread-dev libboost-date-time-dev libboost-test-dev libmpfi-dev ffmpeg libtinyxml-dev libflann-dev sqlite3 libccd-dev liboctomap-dev python-dev python-django python-pip python-beautifulsoup python-django-nose python-coverage cmake-curses-gui}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes"
  end
end
%w{cmake-curses-gui silversearcher-ag}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes"
  end
end
execute "install sympy" do
  command <<-EOS
pip install numpy==1.14.2 sympy==0.7.1 scipy==1.1.0 IPython==5.8.0
  EOS
end
execute "install collada-dom" do
  command <<-EOS
git clone https://github.com/rdiankov/collada-dom.git
cd collada-dom
cmake .
make -j4
make install
cd ..
  EOS
end
execute "install fcl" do
  command <<-EOS
git clone https://github.com/rdiankov/fcl.git
cd fcl
git checkout origin/kenjiSpeedUpAdditions
cmake . -DFCL_BUILD_TESTS=OFF
make -j4
make install
cd ..
  EOS
end
execute "install openrave" do
  command <<-EOS
git clone https://github.com/rdiankov/openrave.git
cd openrave
sed -i -e 's/+pmanager/pmanager/' plugins/fclrave/fclmanagercache.h
cmake .
make -j4
make install
cd ..
  EOS
end
execute "install openrave_sample_app" do
  command <<-EOS
git clone https://github.com/cielavenir/openrave_sample_app.git
cd openrave_sample_app
#makemigrations is done in repo
#python manage.py makemigrations openrave
python manage.py migrate
echo "ready for `python manage.py runserver 0.0.0.0:8000`."
cd ..
  EOS
end
=begin
execute "configure jenkins" do
  command <<-EOS
mkdir /var/lib/jenkins/jobs/openrave_sample_app
wget -O /var/lib/jenkins/jobs/openrave_sample_app/config.xml https://raw.githubusercontent.com/cielavenir/mujin_recruiting/master/jenkins_config.xml
chown -RH jenkins:jenkins /var/lib/jenkins/jobs/openrave_sample_app
echo "configure github to hook http://JENKINS_ROOT/github-webhook/"
  EOS
end
=end
