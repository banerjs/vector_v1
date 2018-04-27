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

## Troubleshooting

### Rendering on a server for kinect2_bridge

- [OpenAI Gym](https://github.com/banerjs/gym#rendering-on-a-server)
- [Debugging XVFB](https://askubuntu.com/questions/754382/how-do-i-start-chromium-browser-in-headless-mode-extension-randr-missing-on-d)
- [Xdummy](http://xpra.org/trac/wiki/Xdummy)

Need to install OpenCL for the NUC and configure docker to expose the Intel GPU:

```
vector@vector2:~/libfreenect2/build$ ./bin/Protonect -noviewer cl
X11 connection rejected because of wrong authentication.
Version: 0.2.0
Environment variables: LOGFILE=<protonect.log>
Usage: ./bin/Protonect [gl | cl | cuda | cpu] [<device serial>]
        [-noviewer] [-norgb | -nodepth] [-help] [-version]
To pause and unpause: pkill -USR1 Protonect
X11 connection rejected because of wrong authentication.
X11 connection rejected because of wrong authentication.
Failed to release test userptr object! (9) i915 kernel driver may not be sane!
X11 connection rejected because of wrong authentication.
X11 connection rejected because of wrong authentication.
Failed to release test userptr object! (9) i915 kernel driver may not be sane!
X11 connection rejected because of wrong authentication.
X11 connection rejected because of wrong authentication.
X11 connection rejected because of wrong authentication.
Failed to release test userptr object! (9) i915 kernel driver may not be sane!
[Info] [OpenCLDepthPacketProcessorImpl]  devices:
[Info] [OpenCLDepthPacketProcessorImpl]   0: Intel(R) Iris Graphics 6100 BroadWell U-Processor GT3 (GPU)[Intel]
[Info] [OpenCLDepthPacketProcessorImpl] selected device: Intel(R) Iris Graphics 6100 BroadWell U-Processor GT3 (GPU)[Intel]
X11 connection rejected because of wrong authentication.
X11 connection rejected because of wrong authentication.
Failed to release test userptr object! (9) i915 kernel driver may not be sane!
X11 connection rejected because of wrong authentication.
[Info] [OpenCLDepthPacketProcessorImpl] building OpenCL program...
[Info] [OpenCLDepthPacketProcessorImpl] OpenCL program built successfully
[Warning] [OpenCLDepthPacketProcessorImpl] Your ocl-icd has deadlock bugs. Update to 2.2.4+ is recommended.
libva info: VA-API version 0.38.1
libva info: va_getDriverName() returns 0
libva info: Trying to open /usr/lib/x86_64-linux-gnu/dri/i965_drv_video.so
libva info: Found init function __vaDriverInit_0_38
libva info: va_openDriver() returns 0
[Info] [VaapiRgbPacketProcessorImpl] driver: Intel i965 driver for Intel(R) Broadwell - 1.6.2
[Info] [Freenect2Impl] enumerating devices...
[Info] [Freenect2Impl] 12 usb devices connected
[Info] [Freenect2Impl] found valid Kinect v2 @2:4 with serial 021708351347
[Info] [Freenect2Impl] found 1 devices
[Info] [Freenect2DeviceImpl] opening...
[Info] [Freenect2DeviceImpl] opened
[Info] [Freenect2DeviceImpl] starting...
[Debug] [Freenect2DeviceImpl] status 0x090000: 9729
[Debug] [Freenect2DeviceImpl] status 0x090000: 9731
[Info] [Freenect2DeviceImpl] submitting rgb transfers...
[Info] [Freenect2DeviceImpl] submitting depth transfers...
[Info] [Freenect2DeviceImpl] started
device serial: 021708351347
device firmware: 4.0.3911.0
[Debug] [DepthPacketStreamParser] not all subsequences received 0
[Info] [OpenCLDepthPacketProcessor] avg. time: 10.1196ms -> ~98.8179Hz
[Info] [VaapiRgbPacketProcessor] avg. time: 12.2342ms -> ~81.7383Hz
The viewer is turned off. Received 100 frames. Ctrl-C to stop.
^C[Info] [Freenect2DeviceImpl] stopping...
[Info] [Freenect2DeviceImpl] canceling rgb transfers...
[Info] [Freenect2DeviceImpl] canceling depth transfers...
[Info] [Freenect2DeviceImpl] stopped
[Info] [Freenect2DeviceImpl] closing...
[Info] [Freenect2DeviceImpl] releasing usb interfaces...
[Info] [Freenect2DeviceImpl] deallocating usb transfer pools...
[Info] [Freenect2DeviceImpl] closing usb device...
[Info] [Freenect2DeviceImpl] closed
[Info] [Freenect2DeviceImpl] closing...
[Info] [Freenect2DeviceImpl] already closed, doing nothing
```

```
sudo apt-get install clang libclang-3.4-dev libclang-dev libclang1 opencl-headers ocl-icd-dev && sudo dpkg -i libfreenect2/depends/debs/ocl-icd*deb && sudo update-alternatives --install /usr/bin/llvm-link llvm-link /usr/bin/llvm-link-3.4 34 &&
sudo update-alternatives --install /usr/bin/llvm-as llvm-as /usr/bin/llvm-as-3.4 34 && sudo apt-get install clinfo
```
