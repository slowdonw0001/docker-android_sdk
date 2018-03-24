
# Dockerfile for Android CTS

## ARG
* ARG ANDROID_SDK_TOOLS_VERSION="3859397"
* ARG ANDROID_CTS_VERSION="7.1_r15"
* ARG ANDROID_CTS_MEDIA_VERSION="1.4"
* ARG ANDROID_SDK_VERSION_MAJOR="26"
* ARG ANDROID_SDK_VERSION_MINOR="0.2"
* ARG GLIBC_VERSION="2.26-r0"

## build

```sh
docker build -t image_name .
```

### build for android cts 7.1_r15
```sh
docker build -t android_cts_7.1_r15 .
```

### build for android cts 8.1_r3
```sh
docker build -t android_cts_8.1_r3 --build-args ANDROID_CTS_VERSION=8.1_r3 .
```
