FROM centos:latest

MAINTAINER Fabiano Florentino <fabiano.apk@gmail.com>

#
# CentOS KEY REPO
#
RUN rpm --import "http://vault.centos.org/RPM-GPG-KEY-CentOS-7"
ADD conf/RPM-GPG-KEY-CentOS-7 /etc/pki/rpm-gpg/

#
# Java 8
#
RUN yum -y update \
    && yum -y install epel-release \
    && yum -y update \
    && yum -y install java-1.8.0-openjdk \
    && yum clean all

#
# Rundeck
#
RUN rpm --import "http://rundeck.org/keys/BUILD-GPG-KEY-Rundeck.org.key"

RUN yum -y install "http://repo.rundeck.org/latest.rpm" \
    && yum -y install rundeck \
    && yum clean all

ADD conf/framework.properties /etc/rundeck/
ADD conf/rundeck-config.properties /etc/rundeck/

USER rundeck

EXPOSE 4440

VOLUME /etc/rundeck
VOLUME /var/rundeck/projects

CMD source /etc/rundeck/profile && \
${JAVA_HOME:-/usr}/bin/java ${RDECK_JVM} -cp ${BOOTSTRAP_CP} com.dtolabs.rundeck.RunServer /var/lib/rundeck ${RDECK_HTTP_PORT}