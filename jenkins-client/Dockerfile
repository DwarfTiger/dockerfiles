FROM arm64v8/openjdk:8-jre

COPY qemu-aarch64-static /usr/bin

RUN /bin/sh -c apt-get update \
    && apt-get install -y --no-install-recommends git mercurial openssh-client subversion procps \
    && rm -rf /var/lib/apt/lists/*
ARG VERSION=4.7
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
RUN |5 VERSION=4.7 gid=1000 group=jenkins uid=1000 user=jenkins /bin/sh -c groupadd -g ${gid} ${group}
RUN |5 VERSION=4.7 gid=1000 group=jenkins uid=1000 user=jenkins /bin/sh -c useradd -c "Jenkins user" -d /home/${user} -u ${uid} -g ${gid} -m ${user}
LABEL Description=This is a base image, which provides the Jenkins agent executable (agent.jar) Vendor=Jenkins project Version=4.7
ARG AGENT_WORKDIR=/home/jenkins/agent
RUN |6 AGENT_WORKDIR=/home/jenkins/agent VERSION=4.7 gid=1000 group=jenkins uid=1000 user=jenkins /bin/sh -c apt-get update \
    && apt-get install git-lfs \
    && rm -rf /var/lib/apt/lists/*
RUN |6 AGENT_WORKDIR=/home/jenkins/agent VERSION=4.7 gid=1000 group=jenkins uid=1000 user=jenkins /bin/sh -c curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar   \
    && chmod 755 /usr/share/jenkins   \
    && chmod 644 /usr/share/jenkins/agent.jar   \
    && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar
USER jenkins
ENV AGENT_WORKDIR=/home/jenkins/agent
RUN |5 VERSION=4.7 gid=1000 group=jenkins uid=1000 user=jenkins /bin/sh -c mkdir /home/${user}/.jenkins \
    && mkdir -p ${AGENT_WORKDIR}
VOLUME [/home/jenkins/.jenkins]
VOLUME [/home/jenkins/agent]
WORKDIR /home/jenkins
ARG version
LABEL Description=This is a base image, which allows connecting Jenkins agents via JNLP protocols Vendor=Jenkins project Version=4.7-1
ARG user=jenkins
USER root
COPY file:ed4fa8a1b7136f090d4af746a0ee86d69625e709c5e2d1d9762f9be8e3da1c92 in /usr/local/bin/jenkins-agent
RUN |2 user=jenkins version=4.7-1 /bin/sh -c chmod +x /usr/local/bin/jenkins-agent \
    &&    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave
USER jenkins
ENTRYPOINT ["/usr/local/bin/jenkins-agent"]

