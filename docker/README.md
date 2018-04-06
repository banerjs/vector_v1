# Dockerized install

This is a work-in-progress. I'll update this constantly every #hack session.

## Overview

The docker files should contain all the code needed to interface with the robot hardware. It contains, but is not capable of using the code used to display the robot state.

So if you want, you can run the simulator server in the docker container, but rviz and gzclient must be run on a host OS that is connected to a display.

## Steps so far

```
docker build -t hlp-r/vector_v1:indigo -f docker/indigo.dockerfile .
docker run -it --rm --privileged -v /dev/bus/usb:/dev/bus/usb hlp-r/vector_v1:indigo bash
```
