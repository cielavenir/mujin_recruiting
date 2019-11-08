execute "update apt package part1" do
  command "apt-get update -y"
end
%w{dirmngr gnupg}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes"
  end
end
execute "add jenkins key" do
  command "wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -"
end
execute "add jenkins source" do
  command "echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list"
end
execute "update apt package part2" do
  command "apt-get update -y"
end
execute "install specific lib" do
  command <<-EOS
if grep '^Debian GNU/Linux' /etc/issue >/dev/null; then
  apt-get install -y openjdk-11-jre-headless
else
  apt-get install -y openjdk-8-jre-headless libsoqt4-dev
fi
  EOS
end
%w{liblog4cxx-dev libboost-numpy-dev libopenscenegraph-dev}.each do |each_package|
  # libopenscenegraph-3.4-dev (and qtbase5-dev) are not compatible with boost-1.6x branchi, which targets to Qt4 OSG!
  package each_package do
    action :install
    options "--force-yes"
  end
end
%w{g++ gfortran git cmake pkg-config debhelper gettext zlib1g-dev libminizip-dev libxml2-dev liburiparser-dev libpcre3-dev libgmp-dev libmpfr-dev}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes"
  end
end
### sorry, need to downgrade coin/soqt on buster ###
execute "downgrade coin/soqt (debian buster)" do
  command <<-EOS
if grep '^Debian GNU/Linux' /etc/issue >/dev/null && [ ! -d soqt ]; then
  mkdir soqt
  git -C /vagrant show origin/soqt_buster:soqt.tar | tar -C soqt -x
  cd soqt
  dpkg -i libcoin80-dev_3.1.4~abc9f50+dfsg1-2_amd64.deb libcoin80-runtime_3.1.4~abc9f50+dfsg1-2_all.deb libcoin80v5_3.1.4~abc9f50+dfsg1-2_amd64.deb libsoqt-dev-common_1.6.0~e8310f-3_amd64.deb libsoqt4-20_1.6.0~e8310f-3_amd64.deb libsoqt4-dev_1.6.0~e8310f-3_amd64.deb
  cd ..
  apt-get -y install -f
fi
  EOS
end
%w{libqt4-dev qt4-dev-tools libavcodec-dev libavformat-dev libswscale-dev libsimage-dev libode-dev libqhull-dev libann-dev libhdf5-serial-dev liblapack-dev libboost-iostreams-dev libboost-regex-dev libboost-filesystem-dev libboost-system-dev libboost-python-dev libboost-thread-dev libboost-date-time-dev libboost-test-dev libmpfi-dev ffmpeg libtinyxml-dev libflann-dev sqlite3 libccd-dev python-dev python-django python-pip python-django-nose python-coverage python-opengl jenkins}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes"
  end
end
#python-beautifulsoup
#some debug app
%w{ninja-build cmake-curses-gui silversearcher-ag}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes"
  end
end
execute "install sympy" do
  command <<-EOS
pip install numpy==1.16.5 sympy==0.7.1 IPython==5.8.0
  EOS
end
#must be different command
execute "install scipy" do
  command <<-EOS
pip install scipy==1.1.0
  EOS
end
=begin
execute "install bullet3 (2.82)" do
  command <<-EOS
git clone https://github.com/bulletphysics/bullet3.git && mkdir bullet3/build
cd bullet3/build
git checkout tags/2.82
cmake .. -GNinja -DINSTALL_LIBS=ON -DBUILD_SHARED_LIBS=ON -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC
ninja -j4 && ninja install
cd ../..
  EOS
end
=end
execute "install collada-dom" do
  command <<-EOS
git clone https://github.com/rdiankov/collada-dom.git && mkdir collada-dom/build
cd collada-dom/build
cmake .. -GNinja
ninja -j4 && ninja install
cd ../..
  EOS
end
execute "install RapidJSON" do
  command <<-EOS
git clone https://github.com/Tencent/rapidjson.git && mkdir rapidjson/build
cd rapidjson/build
cmake .. -GNinja
ninja -j4 && ninja install
cd ../..
  EOS
end
execute "install assimp" do
  command <<-EOS
git clone https://github.com/rdiankov/assimp.git && mkdir assimp/build
cd assimp/build
cmake .. -GNinja
ninja -j4 && ninja install
cd ../..
  EOS
end
execute "install fcl" do
  command <<-EOS
git clone https://github.com/rdiankov/fcl.git && mkdir fcl/build
cd fcl/build
git checkout origin/kenjiSpeedUpAdditions
cmake .. -GNinja -DFCL_BUILD_TESTS=OFF
ninja -j4 && ninja install
cd ../..
  EOS
end
execute "install openrave" do
  command <<-EOS
git clone https://github.com/rdiankov/openrave.git && mkdir openrave/build
cd openrave/build
git remote add ciel https://github.com/cielavenir/openrave.git
git fetch ciel # for some special patch commit
#git config --local user.email 'knife-solo@vagrant.example.com'
#git config --local user.name 'knife-solo'
git checkout ciel/boost-1.6x-forcompile

cmake .. -GNinja -DCMAKE_CXX_FLAGS=-std=gnu++11 -DOPENRAVE_PLUGIN_BULLETRAVE=OFF -DOPENRAVE_PLUGIN_LOGGING=OFF
ninja -j4 && ninja install
cd ../..
  EOS
end
=begin
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
=end
