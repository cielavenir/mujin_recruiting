execute "add backports source" do
  command <<-EOS
if grep '^Debian GNU/Linux 8' /etc/issue >/dev/null; then
  echo deb http://archive.debian.org/debian jessie-backports main > /etc/apt/sources.list.d/backports.list
  echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/ignorevalid.conf
fi
  EOS
end
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
execute "add deb-multimedia source" do
  command <<-EOS
if grep '^Debian GNU/Linux 8' /etc/issue >/dev/null; then
  apt-get install -y ca-certificates-java/jessie-backports openjdk-8-jre-headless/jessie-backports liblog4cxx10-dev
  apt-key adv --keyserver keyserver.ubuntu.com --recv-key 5C808C2B65558117
  echo deb http://www.deb-multimedia.org jessie main non-free > /etc/apt/sources.list.d/multimedia.list
else
  apt-get install -y liblog4cxx-dev
fi
  EOS
end
execute "install libopenscenegraph-3.4-dev (if stretch)" do
  command <<-EOS
if true; then
  apt-get install -y libopenscenegraph-3.4-dev qtbase5-dev
fi
  EOS
end
execute "update apt package part2" do
  command "apt-get update -y"
end
#execute "upgrade apt package" do
#  command "apt-get upgrade -y"
#end
%w{g++ gfortran git cmake pkg-config debhelper gettext zlib1g-dev libminizip-dev libxml2-dev liburiparser-dev libpcre3-dev libgmp-dev libmpfr-dev libqt4-dev qt4-dev-tools libavcodec-dev libavformat-dev libswscale-dev libsimage-dev libode-dev libsoqt4-dev libqhull-dev libann-dev libhdf5-serial-dev liblapack-dev libboost-iostreams-dev libboost-regex-dev libboost-filesystem-dev libboost-system-dev libboost-thread-dev libboost-date-time-dev libboost-test-dev libmpfi-dev pybind11-dev ffmpeg libtinyxml-dev libflann-dev sqlite3 libccd-dev python-dev python-django python-pip python-beautifulsoup python-django-nose python-coverage python-opengl openjdk-8-jre-headless jenkins}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes"
  end
end
#some debug app
%w{ninja-build cmake-curses-gui silversearcher-ag}.each do |each_package|
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
execute "install pybind11" do
  command <<-EOS
git clone https://github.com/pybind/pybind11.git && mkdir pybind11/build
cd pybind11/build
git remote add woody https://github.com/woodychow/pybind11.git
git fetch woody
git config --local user.email 'knife-solo@vagrant.example.com'
git config --local user.name 'knife-solo'

git checkout v2.2.4
git cherry-pick 94824d68a037d99253b92a5b260bb04907c42355
git cherry-pick 98c9f77e5481af4cbc7eb092e1866151461e3508
cmake .. -GNinja -DPYBIND11_TEST=OFF -DPythonLibsNew_FIND_VERSION=2
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
git config --local user.email 'knife-solo@vagrant.example.com'
git config --local user.name 'knife-solo'

#openrave 0.15
#git checkout 951676167e443eec6b40163d4f5b68d0858b74ef # the final version with rapidjson optional
#git cherry-pick addfd9e8baac327d86245515c6d4595a4f05aa59 # https://github.com/rdiankov/openrave/pull/703 (fix fclmanagercache.h)
#cmake ..

#openrave 0.25
git checkout origin/production # detach HEAD
git cherry-pick cb96ec7318af7753e947a333dafe49bf6cacef01 # https://github.com/rdiankov/openrave/pull/706 (fix bulletrave compilation)
git cherry-pick 53b90e081139a8d9c903d2e702322ba97a8bc494
git cherry-pick 40d1e31e431523bfd1ec2c0a7c351a008ca93f91 # https://github.com/rdiankov/openrave/pull/708 (fix FCL_LDFLAGS)
git cherry-pick 18831785c536f801f1af66fffff7eb7bec60d8e8
cmake .. -GNinja -DUSE_PYBIND11_PYTHON_BINDINGS=ON -DCMAKE_CXX_FLAGS=-std=gnu++11
if grep '^Debian GNU/Linux 8' /etc/issue >/dev/null; then
  # workaround for broken libstdc++ 4.9 C++11 mode
  # https://stackoverflow.com/a/33770530/2641271
  cmathLineno=$(grep -n cmath ../plugins/ikfastsolvers/plugindefs.h|cut -d: -f1)
  cat << EOM | sed -i "${cmathLineno}r /dev/stdin" ../plugins/ikfastsolvers/plugindefs.h
#if __cplusplus <= 199711L  // c++98 or older
#  define isnan(x) ::isnan(x)
#else
#  define isnan(x) std::isnan(x)
#endif
EOM
fi

ninja -j4 && ninja install
cd ../..
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
