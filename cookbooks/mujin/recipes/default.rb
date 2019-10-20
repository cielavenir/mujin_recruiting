execute "add backports source" do
  command <<-EOS
if grep ^Debian /etc/issue >/dev/null; then
  echo deb http://archive.debian.org/debian jessie-backports main > /etc/apt/sources.list.d/backports.list
  echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/ignorevalid.conf
fi
  EOS
end
execute "add jenkins key" do
  command "wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -"
end
execute "add jenkins source" do
  command "echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list"
end
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
if grep ^Debian /etc/issue >/dev/null; then
  apt-get install -y ca-certificates-java/jessie-backports openjdk-8-jre-headless/jessie-backports liblog4cxx10-dev
  apt-key adv --keyserver keyserver.ubuntu.com --recv-key 5C808C2B65558117
  echo deb http://www.deb-multimedia.org jessie main non-free > /etc/apt/sources.list.d/multimedia.list
else
  apt-get install -y liblog4cxx-dev
fi
  EOS
end
execute "update apt package part2" do
  command "apt-get update -y"
end
#execute "upgrade apt package" do
#  command "apt-get upgrade -y"
#end
%w{g++ gfortran git cmake pkg-config debhelper gettext zlib1g-dev libminizip-dev libxml2-dev liburiparser-dev libpcre3-dev libgmp-dev libmpfr-dev libassimp-dev libqt4-dev qt4-dev-tools libavcodec-dev libavformat-dev libswscale-dev libsimage-dev libode-dev libsoqt4-dev libqhull-dev libann-dev libbullet-dev libopenscenegraph-dev libhdf5-serial-dev liblapack-dev libboost-iostreams-dev libboost-regex-dev libboost-filesystem-dev libboost-system-dev libboost-python-dev libboost-thread-dev libboost-date-time-dev libboost-test-dev libmpfi-dev ffmpeg libtinyxml-dev libflann-dev sqlite3 libccd-dev liboctomap-dev python-dev python-django python-pip python-beautifulsoup python-django-nose python-coverage openjdk-8-jre-headless jenkins}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes"
  end
end
#some debug app
%w{cmake-curses-gui silversearcher-ag}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes"
  end
end
execute "install sympy" do
  command <<-EOS
pip install numpy==1.14.2 sympy==0.7.1 IPython==5.8.0
  EOS
end
#must be different command
execute "install scipy" do
  command <<-EOS
pip install scipy==1.1.0
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
execute "install RapidJSON" do
  command <<-EOS
git clone https://github.com/Tencent/rapidjson.git
cd rapidjson
cmake .
make -j4
make install
cd ..
  EOS
end
execute "install assimp" do
  command <<-EOS
git clone https://github.com/rdiankov/assimp.git
cd assimp
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

#openrave 0.15
#git checkout 951676167e443eec6b40163d4f5b68d0858b74ef
#sed -i -e 's/+pmanager/pmanager/' plugins/fclrave/fclmanagercache.h # https://github.com/rdiankov/openrave/pull/703
#cmake .

#openrave 0.24
sed -i -e 's/pmeta->getName()/string(pmeta->getName())/' src/libopenrave-core/colladaparser/colladareader.cpp # https://github.com/rdiankov/openrave/pull/705
cmake . -DCMAKE_CXX_FLAGS=-std=gnu++11 -DOPENRAVE_PLUGIN_BULLETRAVE=OFF # disable bulletrave until https://github.com/rdiankov/openrave/pull/706 is resolved
if grep ^Debian /etc/issue >/dev/null; then
  # workaround for broken libstdc++ 4.9 C++11 mode
  # https://stackoverflow.com/a/33770530/2641271
  cmathLineno=$(grep -n cmath plugins/ikfastsolvers/plugindefs.h|cut -d: -f1)
  cat << EOM | sed -i "${cmathLineno}r /dev/stdin" plugins/ikfastsolvers/plugindefs.h
#if __cplusplus <= 199711L  // c++98 or older
#  define isnan(x) ::isnan(x)
#else
#  define isnan(x) std::isnan(x)
#endif
EOM
fi

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
echo 'ready for `python manage.py runserver 0.0.0.0:8000`.'
cd ..
  EOS
end
execute "configure jenkins" do
  command <<-EOS
mkdir /var/lib/jenkins/jobs/openrave_sample_app
wget -O /var/lib/jenkins/jobs/openrave_sample_app/config.xml https://raw.githubusercontent.com/cielavenir/mujin_recruiting/master/jenkins_config.xml
chown -RH jenkins:jenkins /var/lib/jenkins/jobs/openrave_sample_app
echo "configure github to hook http://JENKINS_ROOT/github-webhook/"
  EOS
end
