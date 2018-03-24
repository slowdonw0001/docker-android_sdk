
FROM openjdk:8-jdk-alpine

MAINTAINER ss

# Environment variables
ENV ANDROID_HOME /usr/local/android-sdk-linux
ARG ANDROID_SDK_TOOLS_VERSION="3859397"
ARG ANDROID_CTS_VERSION="7.1_r15"
ARG ANDROID_CTS_MEDIA_VERSION="1.4"
ARG ANDROID_SDK_VERSION_MAJOR="26"
ARG ANDROID_SDK_VERSION_MINOR="0.2"
ARG GLIBC_VERSION="2.26-r0"

# path
ENV PATH $ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/build-tools/${ANDROID_SDK_VERSION_MAJOR}.${ANDROID_SDK_VERSION_MINOR}:$PATH

# Install sudo
RUN apk --update add sudo
RUN adduser -S docker \
    && echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && echo 'docker:docker' | chpasswd

# Install package
RUN sudo apk add --no-cache wget unzip bash git

RUN wget https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub -O /etc/apk/keys/sgerrand.rsa.pub 2&> /dev/null \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -O /tmp/glibc.apk 2&> /dev/null \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk -O /tmp/glibc-bin.apk 2&> /dev/null \
    && apk add /tmp/glibc.apk /tmp/glibc-bin.apk \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/*

# Download Android SDK
RUN mkdir -p $ANDROID_HOME \
    && cd $ANDROID_HOME \
    && wget https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip 2&> /dev/null \
    && unzip sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip \
    && rm -rf $ANDROID_HOME/sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip

# Download CTS
RUN cd /usr/local \
    && wget https://dl.google.com/dl/android/cts/android-cts-${ANDROID_CTS_VERSION}-linux_x86-arm.zip 2&> /dev/null \
    && unzip android-cts-${ANDROID_CTS_VERSION}-linux_x86-arm.zip \
    && rm -rf /usr/local/android-cts-${ANDROID_CTS_VERSION}-linux_x86-arm.zip

# Download CTS-MEDIA
RUN cd /usr/local \
    && wget https://dl.google.com/dl/android/cts/android-cts-media-${ANDROID_CTS_MEDIA_VERSION}.zip 2&> /dev/null \
    && unzip android-cts-media-${ANDROID_CTS_MEDIA_VERSION}.zip \
    && rm -rf /usr/local/android-cts-media-${ANDROID_CTS_MEDIA_VERSION}.zip

# Licence of Android SDK
RUN mkdir -p ${ANDROID_HOME}/licenses/
RUN echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > ${ANDROID_HOME}/licenses/android-sdk-license
RUN echo "d56f5187479451eabf01fb78af6dfcb131a6481e" >> ${ANDROID_HOME}/licenses/android-sdk-license
RUN echo "84831b9409646a918e30573bab4c9c91346d8abd" > ${ANDROID_HOME}/licenses/android-sdk-preview-license

# Update of Android SDK
RUN (while sleep 3; do echo "y"; done) \
        | android update sdk --no-ui --all --filter \
        "android-${ANDROID_SDK_VERSION_MAJOR},build-tools-${ANDROID_SDK_VERSION_MAJOR}.${ANDROID_SDK_VERSION_MINOR},platform-tools"

# additional path
# ENV PATH $ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/build-tools/${ANDROID_SDK_VERSION_MAJOR}.${ANDROID_SDK_VERSION_MINOR}:$PATH

ENV LANG=C.UTF-8

# to readlink of android-cts 8.1_r3
RUN sudo apk add --no-cache coreutils

RUN mkdir -p /usr/local/android-cts/results
RUN mkdir -p /usr/local/android-cts/logs

VOLUME /usr/local/android-cts/results
VOLUME /usr/local/android-cts/logs
WORKDIR /usr/local/android-cts/tools

ENTRYPOINT [ "/bin/bash" ]
