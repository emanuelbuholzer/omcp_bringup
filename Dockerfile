ARG ROS_DISTRO="humble"

FROM docker.io/ros:${ROS_DISTRO}

# See https://github.com/opencontainers/runc/issues/2517
RUN echo 'APT::Sandbox::User "root";' > /etc/apt/apt.conf.d/sandbox-disable

ENV ROS_OVERLAY /opt/ros/omcp

WORKDIR $ROS_OVERLAY

COPY resource src/omcp_bringup/resource
COPY package.xml src/omcp_bringup/package.xml
COPY setup.cfg src/omcp_bringup/setup.cfg
COPY setup.py src/omcp_bringup/setup.py
COPY launch src/omcp_bringup/launch

RUN git clone https://github.com/emanuelbuholzer/ros2_blender.git src/ros2_blender
RUN git clone https://github.com/emanuelbuholzer/omcp_blender.git src/omcp_blender

RUN apt-get update && \
    rosdep install -iy --from-paths src && \
    rm -rf /var/lib/apt/lists/

RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
    colcon build --symlink-install --continue-on-error

RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
    colcon test ; \
    colcon test-result --verbose

RUN sed --in-place --expression \
    '$isource "${ROS_OVERLAY}/install/setup.bash"' \
    /ros_entrypoint.sh
