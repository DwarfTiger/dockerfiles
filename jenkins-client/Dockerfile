FROM arm64v8/openjdk:8-jre

COPY qemu-aarch64-static /usr/bin

RUN apt-get update \
    && apt-get install -y --no-install-recommends git mercurial openssh-client subversion procps \
    && rm -rf /var/lib/apt/lists/*
ARG VERSION=4.7
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
RUN groupadd -g $gid $group
RUN useradd -c "Jenkins user" -d /home/$user -u $uid -g $gid -m $user
LABEL Description="This is a base image, which provides the Jenkins agent executable (agent.jar) Vendor=Jenkins project Version=4.7"
ARG AGENT_WORKDIR=/home/jenkins/agent
RUN apt-get update \
    && apt-get install git-lfs \
    && rm -rf /var/lib/apt/lists/*
RUN curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$VERSION/remoting-$VERSION.jar   \
    && chmod 755 /usr/share/jenkins   \
    && chmod 644 /usr/share/jenkins/agent.jar   \
    && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar
USER jenkins
ENV AGENT_WORKDIR=/home/jenkins/agent
RUN mkdir /home/$user/.jenkins \
    && mkdir -p $AGENT_WORKDIR
VOLUME [/home/jenkins/.jenkins]
VOLUME [/home/jenkins/agent]
WORKDIR /home/jenkins
ARG version
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols Vendor=Jenkins project Version=4.7-1"
ARG user=jenkins
USER root
COPY ./jenkins-agent /usr/local/bin/jenkins-agent
RUN chmod +x /usr/local/bin/jenkins-agent \
    && ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave
RUN apt-get update \
    && apt install -y apt-transport-https software-properties-common gnupg2 \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt update \
    && apt install -y --no-install-recommends docker-ce \
    && rm -rf /var/lib/apt/lists/*
USER jenkins
ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
