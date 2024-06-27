FROM ubuntu:22.04 AS BASE

RUN apt-get -y update

#install gcc and libraries to build arrow
RUN apt install -y software-properties-common
RUN apt install -y maven build-essential cmake libssl-dev libre2-dev libcurl4-openssl-dev clang lldb lld libz-dev git ninja-build uuid-dev autoconf-archive curl zip unzip tar pkg-config bison libtool flex vim

#velox script needs sudo to install dependency libraries
RUN apt install -y sudo

# make sure jemalloc is uninstalled, jemalloc will be build in vcpkg, which conflicts with the default jemalloc in system
RUN apt -y purge libjemalloc-dev libjemalloc2 librust-jemalloc-sys-dev

#make sure jdk8 is used. New version of jdk is not supported
RUN apt install -y openjdk-8-jdk
RUN apt install -y default-jdk
RUN export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN export PATH=$JAVA_HOME/bin:$PATH

#manually install tzdata to avoid the interactive timezone config
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
RUN dpkg --configure -a

#setup proxy on necessary
#export http_proxy=xxxx
#export https_proxy=xxxx

#clone gluten
RUN git clone https://github.com/oap-project/gluten.git

WORKDIR /gluten

#config maven proxy
#mkdir ~/.m2/
#vim ~/.m2/settings.xml

# the script download velox & arrow and compile all dependency library automatically
# To access HDFS or S3, you need to add the parameters `--enable_hdfs=ON` and `--enable_s3=ON`
# It's suggested to build using static link, enabled by `--enable_vcpkg=ON`
# For developer, it's suggested to enable Debug info, by --build_type=RelWithDebInfo. Note RelWithDebInfo uses -o2, release uses -o3
RUN ./dev/buildbundle-veloxbe.sh \
    --enable_vcpkg=ON \
    --enable_hdfs=ON \
    --enable_s3=ON \
    --build_type=RelWithDebInfo

CMD ["bin/bash"]