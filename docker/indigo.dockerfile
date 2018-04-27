# Create an image to load and install the HLPR code

FROM ros:indigo

# Set any environment variables that need to be overridden here
ARG HLPR_USER
ARG WORKSPACE_DIR
ARG REPOSITORY_DIR

ENV HLPR_USER=${HLPR_USER:-hlpr} \
    WORKSPACE_DIR=${WORKSPACE_DIR:-/home/hlpr/catkin_ws} \
    REPOSITORY_DIR=${REPOSITORY_DIR:-/home/hlpr/software/vector_v1}

# Install the prerequisite files from apt-get
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        python-software-properties && \
    apt-get install -y --no-install-recommends \
        ros-indigo-desktop-full \
        ros-indigo-control-toolbox \
        ros-indigo-moveit-core \
        ros-indigo-costmap-2d \
        ros-indigo-move-base \
        ros-indigo-jsk-recognition \
        ros-indigo-controller-manager \
        ros-indigo-gazebo-ros* \
        ros-indigo-hector* \
        ros-indigo-rviz-imu-plugin \
        ros-indigo-robot-pose-ekf \
        ros-indigo-robot-localization \
        ros-indigo-yocs-cmd-vel-mux \
        ros-indigo-joint-* \
        libnlopt-dev \
        python-easygui \
        build-essential \
        sudo \
        wget \
        curl \
        rsync \
        libturbojpeg \
        libjpeg-turbo8-dev \
        pkg-config \
        xvfb \
        x11-utils \
        x11-xserver-utils \
        xserver-xorg-video-dummy \
        xpra \
        mesa-utils

# Change the user
RUN useradd -r -m -U -G sudo,tty,video,dialout ${HLPR_USER} && \
    echo "ALL   ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir -p $WORKSPACE_DIR /home/$HLPR_USER/software && \
    chown -R $HLPR_USER:$HLPR_USER $WORKSPACE_DIR && \
    chown -R $HLPR_USER:$HLPR_USER /home/$HLPR_USER/software
USER $HLPR_USER

# Install libfreenect
RUN cd $HOME/software && \
    git clone -b v0.2.0 https://github.com/OpenKinect/libfreenect2.git && \
    cd libfreenect2 && cd depends && ./download_debs_trusty.sh && \
    sudo dpkg -i debs/libusb*deb && \
    sudo dpkg -i debs/libglfw3*deb && sudo apt-get install -f
    # sudo apt-add-repository -y ppa:floe/beignet && \
    #     sudo apt-get update && \
    #     sudo apt-get install -y beignet-dev && \
    #     sudo dpkg -i debs/ocl-icd*deb && \
    # cd .. && mkdir build && cd build && \
    # cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/software/freenect2 -Dfreenect2_DIR=$HOME/software/freenect2/lib/cmake/freenect2 -DENABLE_CXX11=ON && \
    # make && make install && \
    # sudo cp ../platform/linux/udev/90-kinect2.rules /etc/udev/rules.d/ && \
    # sudo ln -sf $HOME/software/freenect2/lib/cmake/freenect2/freenect2Config.cmake /usr/share/cmake-2.8/Modules/Findfreenect2.cmake

# Clone and build the repository
# COPY . $REPOSITORY_DIR
# RUN cd $WORKSPACE_DIR && mkdir src && cd src && \
#     . /opt/ros/indigo/setup.sh && catkin_init_workspace && \
#     cd .. && ln -sf $REPOSITORY_DIR src/ && \
#     catkin_make && \
#     sudo cp src/vector_v1/docker/utils/hector_pose_estimation_nodelets.fix.xml /opt/ros/indigo/share/hector_pose_estimation/hector_pose_estimation_nodelets.xml

# Set the work directory
WORKDIR $WORKSPACE_DIR

# TODO: Create the entrypoint and the commands
