### experimental: in this flavor, to link lapack statically, libgfortran-N-dev must be installed. the number N is not predictable. ###

execute "update apt package part1" do
  command "apt-get update -y"
end
%w{dirmngr gnupg apt-transport-https liblog4cxx-dev}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes --no-install-recommends"
  end
end
execute "add jenkins source" do
  command <<-'EOS'
set -e
wget -q --no-check-certificate -O - https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo apt-key add -
echo deb https://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list
echo "Acquire { https::Verify-Peer false }" >> /etc/apt/apt.conf.d/99verify-peer.conf
  EOS
end
if (node[:platform]=='ubuntu' && ['20.04','22.04','24.04'].include?(node[:platform_version])) ||
   (node[:platform]=='debian' && (node[:platform_version].to_i>=11 || ['bullseye','bookworm'].any?{|ver|node[:platform_version].start_with?(ver)}))
  %w{libopenscenegraph-dev python2-dev python-setuptools}.each do |each_package|
    package each_package do
      action :install
      options "--force-yes --no-install-recommends"
    end
  end
  execute "install pip" do
    command <<-'EOS'
set -e
python2 -m easy_install pip~=20.0
    EOS
  end
else
  %w{libopenscenegraph-3.4-dev python-dev python-django python-django-nose python-setuptools python-pip}.each do |each_package|
    package each_package do
      action :install
      options "--force-yes --no-install-recommends"
    end
  end
  unless (node[:platform]=='debian'&&node[:platform_version].to_i==10)
    %w{python-beautifulsoup}.each do |each_package|
      package each_package do
        action :install
        options "--force-yes --no-install-recommends"
      end
    end
  end
end
%w{python3-dev python3-setuptools python3-pip python3-nose}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes --no-install-recommends"
  end
end
if (node[:platform]=='ubuntu' && ['20.04','22.04','24.04'].include?(node[:platform_version])) ||
   (node[:platform]=='debian' && (node[:platform_version].to_i>=10 || ['buster','bullseye','bookworm'].any?{|ver|node[:platform_version].start_with?(ver)}))
  %w{libcoin-dev libsoqt520-dev}.each do |each_package|
    package each_package do
	  action :install
	  options "--force-yes --no-install-recommends"
    end
  end
end
execute "update apt package part2" do
  command "apt-get update -y"
end
#execute "upgrade apt package" do
#  command "apt-get upgrade -y"
#end
%w{clang git pkg-config debhelper gettext libxml2-dev liburiparser-dev libpcre3-dev libgmp-dev libmpfr-dev qtbase5-dev libqt5opengl5-dev libavcodec-dev libavformat-dev libswscale-dev libsimage-dev libode-dev libhdf5-serial-dev liblapack-dev libboost-iostreams-dev libboost-regex-dev libboost-filesystem-dev libboost-system-dev libboost-thread-dev libboost-date-time-dev libboost-test-dev libmpfi-dev ffmpeg libtinyxml-dev libflann-dev sqlite3 libccd-dev libeigen3-dev libgpgme-dev libgpgmepp-dev}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes --no-install-recommends"
  end
end

# CMake 3.10+ is required for the constant `OpenGL::OpenGL`.
if (node[:platform]=='debian'&&node[:platform_version].to_i==9)
  execute "install cmake" do
    command <<-'EOS'
echo 'deb http://ftp.debian.org/debian stretch-backports main contrib' | sudo tee /etc/apt/sources.list.d/backports.list
echo 'deb http://ftp.debian.org/debian stretch-backports-sloppy main contrib' | sudo tee -a /etc/apt/sources.list.d/backports.list
apt-get update -y
apt install -y --force-yes --no-install-recommends libarchive13/stretch-backports-sloppy
apt install -y --force-yes --no-install-recommends cmake-data/stretch-backports cmake/stretch-backports cmake-curses-gui/stretch-backports libglvnd-dev/stretch-backports libegl1/stretch-backports libglx0/stretch-backports libegl-mesa0/stretch-backports libglx-mesa0/stretch-backports libdrm-dev/stretch-backports libegl1-mesa/stretch-backports libgl1-mesa-dev/stretch-backports libgl1-mesa-glx/stretch-backports libwayland-egl1-mesa/stretch-backports
    EOS
  end
else
  if (node[:platform]=='ubuntu'&&node[:platform_version]=='16.04')
    execute "add cmake source" do
      command <<-'EOS'
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc | sudo apt-key add -
echo 'deb https://apt.kitware.com/ubuntu/ xenial main' | sudo tee /etc/apt/sources.list.d/kitware.list
apt-get update -y
      EOS
    end
  end

  %w{cmake-data cmake cmake-curses-gui}.each do |each_package|
    package each_package do
      action :install
      options "--force-yes --no-install-recommends"
    end
  end
end

if (node[:platform]=='ubuntu' && ['22.04','24.04'].include?(node[:platform_version])) ||
   (node[:platform]=='debian' && (node[:platform_version].to_i>=10 || ['buster','bullseye','bookworm'].any?{|ver|node[:platform_version].start_with?(ver)}))
  %w{openjdk-11-jre-headless jenkins}.each do |each_package|
    package each_package do
      action :install
      options "--force-yes --no-install-recommends"
    end
  end
  execute "install pyopengl" do
    command <<-'EOS'
set -e
python2 -m pip install pyopengl
    EOS
  end
else
  %w{python-coverage python-opengl openjdk-8-jre-headless jenkins}.each do |each_package|
    package each_package do
      action :install
      options "--force-yes --no-install-recommends"
    end
  end
end

%w{python3-coverage python3-opengl}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes --no-install-recommends"
  end
end

#some debug app
%w{ninja-build silversearcher-ag}.each do |each_package|
  package each_package do
    action :install
    options "--force-yes --no-install-recommends"
  end
end
execute "install sympy (1)" do
  command <<-'EOS'
set -e
python2 -m pip install numpy==1.16.5 sympy==0.7.1 IPython==5.10.0
python3 -m pip install numpy==1.24.3 IPython==8.14.0
  EOS
end

# sympy 0.7.1  : Incompatible with Python3
# sympy 0.7.2  : SympifyError: SympifyError: None
# sympy 0.7.3  : Somehow partially compatible but there can happen some unresolved variables...
# sympy 0.7.4+ : TypeError: symbolic boolean expression has no truth value.
execute "install sympy (2)" do
  # The only way is to port sympy 0.7.1 to Python3...!
  command <<-'EOS'
set -e
python3 -m pip install https://github.com/cielavenir/sympy/releases/download/0.7.1-py3/sympy-0.7.1-py3.tar.gz
  EOS
end

#must be different command
execute "install scipy" do
  command <<-'EOS'
set -e
python2 -m pip install scipy==1.2.3
python3 -m pip install scipy==1.10.1
  EOS
end
execute "install bullet3 (2.82)" do
  command <<-'EOS'
set -e
git clone https://github.com/bulletphysics/bullet3.git && mkdir bullet3/build
cd bullet3/build
git checkout 2.82
cmake .. -GNinja -DINSTALL_LIBS=ON -DBUILD_SHARED_LIBS=ON -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC
ninja -j4 && ninja install
cd ../..
  EOS
end
execute "install RapidJSON" do
  command <<-'EOS'
set -e
git clone https://github.com/Tencent/rapidjson.git && mkdir rapidjson/build
cd rapidjson/build
# there are no stable version available
cmake .. -GNinja -DRAPIDJSON_HAS_STDSTRING=ON -DRAPIDJSON_BUILD_DOC=OFF -DRAPIDJSON_BUILD_EXAMPLES=OFF -DRAPIDJSON_BUILD_TESTS=OFF
ninja -j4 && ninja install
cd ../..
  EOS
end
execute "install assimp" do
  command <<-'EOS'
set -e
git clone https://github.com/assimp/assimp.git && mkdir assimp/build
cd assimp/build
git checkout v5.2.5
cmake .. -GNinja
ninja -j4 && ninja install
cd ../..
  EOS
end
execute "install fcl" do
  command <<-'EOS'
set -e
git clone https://github.com/rdiankov/fcl.git && mkdir fcl/build
cd fcl/build
git checkout origin/trimeshContactPoints20200813
cmake .. -GNinja -DFCL_BUILD_TESTS=OFF
ninja -j4 && ninja install
cd ../..
  EOS
end
#=begin
execute "install pybind11" do
  command <<-'EOS'
set -e
git clone https://github.com/pybind/pybind11.git && mkdir pybind11/build
cd pybind11/build
# git remote add woody https://github.com/woodychow/pybind11.git
# git fetch woody
git remote add ciel https://github.com/cielavenir/pybind11.git
git fetch ciel
git checkout ciel/v2.9_ty

cmake .. -GNinja -DPYBIND11_TEST=OFF -DPythonLibsNew_FIND_VERSION=2
ninja -j4 && ninja install
cd ../..
  EOS
end
#=end
=begin
execute "install pybind11" do
  command <<-'EOS'
set -e
git clone https://github.com/pybind/pybind11.git && mkdir pybind11/build
cd pybind11/build
git checkout v2.9.2

cmake .. -GNinja -DPYBIND11_TEST=OFF -DPythonLibsNew_FIND_VERSION=2
ninja -j4 && ninja install
cd ../..
  EOS
end
=end
execute "install msgpack-c" do
  command <<-'EOS'
set -e
git clone https://github.com/msgpack/msgpack-c && mkdir msgpack-c/build
cd msgpack-c/build
git checkout cpp-6.0.0

cmake .. -GNinja -DMSGPACK_BUILD_EXAMPLES=OFF -DMSGPACK_BUILD_TESTS=OFF
ninja -j4 && ninja install
cd ../..
  EOS
end
execute "install openrave" do
  command <<-'EOS'
# set -e
git clone https://github.com/rdiankov/openrave.git && mkdir openrave/build
cd openrave/build
# git remote add ciel https://github.com/cielavenir/openrave.git
# git fetch ciel # for some special patch commit
git config --local user.email 'knife-solo@vagrant.example.com'
git config --local user.name 'knife-solo'

if [ ! -f ../__chef_patched__ ]; then
git checkout origin/production # detach HEAD
git cherry-pick cb96ec7318af7753e947a333dafe49bf6cacef01 # [fixbulletrave] https://github.com/rdiankov/openrave/pull/706 (fix bulletrave compilation)
git cherry-pick 53b90e081139a8d9c903d2e702322ba97a8bc494
git cherry-pick bb7e3d83f1bb6e93692f9557c205a7307c4beeb6
git cherry-pick 4828cebfbcefb1941e6715aef32f54008ed30f8c
git cherry-pick 62998a607ec7a6f4b3a7614f9f59ccb8acf9415f # [fix_bug_633_cherrypick] https://github.com/rdiankov/openrave/pull/640 squashed (Replace semicollons in FCL_LDFLAGS with spaces)
touch ../__chef_patched__
fi

FLAG_CMAKE_CXX_STANDARD=""
if grep '^Ubuntu J' /etc/issue >/dev/null || grep '^Ubuntu 22' /etc/issue >/dev/null || grep '^Debian GNU/Linux 12' /etc/issue >/dev/null || grep '^Debian GNU/Linux bookworm' /etc/issue >/dev/null; then
  FLAG_CMAKE_CXX_STANDARD="-DCMAKE_CXX_STANDARD=17"
fi

# https://cmake.org/cmake/help/latest/module/FindBoost.html#boost-cmake
cmake .. -GNinja -DUSE_PYBIND11_PYTHON_BINDINGS=ON ${FLAG_CMAKE_CXX_STANDARD}

ninja -j4 && ninja install
cd ../..

# https://bugs.launchpad.net/ubuntu/+source/python3-stdlib-extensions/+bug/1832215
for ver in 3.8 3.9 3.10 3.11 3.12 3.13; do
  if [ -d /usr/local/lib/python${ver} ] && [ ! -d /usr/local/lib/python${ver}/dist-packages/openravepy ]; then
    ln -s /usr/local/lib/python3/dist-packages/openravepy /usr/local/lib/python${ver}/dist-packages/openravepy
    ln -s /usr/local/lib/python3/dist-packages/sympy /usr/local/lib/python${ver}/dist-packages/sympy
  fi
done
  EOS
end
execute "install openrave_sample_app" do
  command <<-'EOS'
# set -e
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
  command <<-'EOS'
set -e
mkdir /var/lib/jenkins/jobs/openrave_sample_app
wget -O /var/lib/jenkins/jobs/openrave_sample_app/config.xml https://raw.githubusercontent.com/cielavenir/mujin_recruiting/master/jenkins_config.xml
chown -RH jenkins:jenkins /var/lib/jenkins/jobs/openrave_sample_app
echo "configure github to hook http://JENKINS_ROOT/github-webhook/"
  EOS
end
