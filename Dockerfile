# from registry.cn-hangzhou.aliyuncs.com/rancococ/jenkins-jnlp-slave:3.29.4-alpine
FROM registry.cn-hangzhou.aliyuncs.com/rancococ/jenkins-jnlp-slave:3.29.4-alpine

# maintainer
MAINTAINER "rancococ" <rancococ@qq.com>

# set arg info
ARG USER=jenkins
ARG MAVEN_VERSION=3.6.1
ARG MAVEN_HOME=/usr/local/maven
ARG MAVEN_URL=https://mirrors.huaweicloud.com/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz

# set environment
ENV M2_HOME=${MAVEN_HOME}
ENV MAVEN_HOME=${MAVEN_HOME}

# set current user
USER root

# install maven
RUN curl --create-dirs -fsSLo /tmp/maven/apache-maven.tar.gz ${MAVEN_URL} && \
    mkdir -p ${MAVEN_HOME} && \
    tar xzf /tmp/maven/apache-maven.tar.gz --directory=${MAVEN_HOME} --strip-components=1 && \
    chown -R jenkins:jenkins /usr/local/maven && \
    ln -s /usr/local/maven/bin/mvn /usr/local/bin/mvn && \
    \rm -rf /tmp/maven

# set current user
USER ${USER}

# mkdir .m2 and generate
RUN mkdir /home/${USER}/.m2 && \
    mkdir -p /home/${USER}/.m2/repository && \
    touch /home/${USER}/.m2/settings.xml && \
    echo '<?xml version="1.0" encoding="UTF-8"?>' >> /home/${USER}/.m2/settings.xml && \
    echo '<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"' >> /home/${USER}/.m2/settings.xml && \
    echo '    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' >> /home/${USER}/.m2/settings.xml && \
    echo '    xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">' >> /home/${USER}/.m2/settings.xml && \
    echo '    <localRepository>${user.home}/.m2/repository</localRepository>' >> /home/${USER}/.m2/settings.xml && \
    echo '    <mirrors>' >> /home/${USER}/.m2/settings.xml && \
    echo '        <mirror>' >> /home/${USER}/.m2/settings.xml && \
    echo '            <id>aliyun-mirror</id>' >> /home/${USER}/.m2/settings.xml && \
    echo '            <mirrorOf>*</mirrorOf>' >> /home/${USER}/.m2/settings.xml && \
    echo '            <name>aliyun-mirror</name>' >> /home/${USER}/.m2/settings.xml && \
    echo '            <url>https://maven.aliyun.com/repository/public/</url>' >> /home/${USER}/.m2/settings.xml && \
    echo '        </mirror>' >> /home/${USER}/.m2/settings.xml && \
    echo '    </mirrors>' >> /home/${USER}/.m2/settings.xml && \
    echo '</settings>' >> /home/${USER}/.m2/settings.xml

# set volume info
VOLUME /home/${USER}/.m2
