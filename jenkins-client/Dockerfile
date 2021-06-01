FROM arm64v8/openjdk:8-jre

COPY qemu-aarch64-static /usr/bin

RUN /bin/sh -c set -eux; 	apt-get update; 	apt-get install -y --no-install-recommends 		ca-certificates 		curl 		netbase   wget; 	rm -rf /var/lib/apt/lists/*
RUN /bin/sh -c set -ex; 	if ! command -v gpg > /dev/null; then 		apt-get update; 		apt-get install -y --no-install-recommends 		  gnupg 			dirmngr 		; 		rm -rf /var/lib/apt/lists/*; 	fi
RUN /bin/sh -c apt-get update \
    && apt-get install -y --no-install-recommends 		git 		mercurial 		openssh-client 		subversion 				procps 	\
    && rm -rf /var/lib/apt/lists/*
RUN /bin/sh -c set -eux; 	apt-get update; 	apt-get install -y --no-install-recommends 		bzip2 		unzip 		xz-utils 		  fontconfig libfreetype6 				ca-certificates p11-kit 	; 	rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/local/openjdk-8
RUN /bin/sh -c { echo '#/bin/sh'; echo 'echo "$JAVA_HOME"'; } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home \
    && [ "$JAVA_HOME" = "$(docker-java-home)" ] # backwards compatibility
ENV PATH=/usr/local/openjdk-8/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG=C.UTF-8
ENV JAVA_VERSION=8u282
RUN /bin/sh -c set -eux; 		arch="$(dpkg --print-architecture)"; 	case "$arch" in 		'amd64') 			downloadUrl='https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u282-b08/OpenJDK8U-jdk_x64_linux_8u282b08.tar.gz'; 			;; 		*) echo >&2 "error: unsupported architecture: '$arch'"; exit 1 ;; 	esac; 		wget --progress=dot:giga -O openjdk.tgz "$downloadUrl"; 	wget --progress=dot:giga -O openjdk.tgz.asc "$downloadUrl.sign"; 		export GNUPGHOME="$(mktemp -d)"; 	gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys EAC843EBD3EFDB98CC772FADA5CD6035332FA671; 	gpg --batch --keyserver ha.pool.sks-keyservers.net --keyserver-options no-self-sigs-only --recv-keys CA5F11C6CE22644D42C6AC4492EF8D39DC13168F; 	gpg --batch --list-sigs --keyid-format 0xLONG CA5F11C6CE22644D42C6AC4492EF8D39DC13168F 		| tee /dev/stderr 		| grep '0xA5CD6035332FA671' 		| grep 'Andrew Haley'; 	gpg --batch --verify openjdk.tgz.asc openjdk.tgz; 	gpgconf --kill all; 	rm -rf "$GNUPGHOME"; 		mkdir -p "$JAVA_HOME"; 	tar --extract 		--file openjdk.tgz 		--directory "$JAVA_HOME" 		--strip-components 1 		--no-same-owner 	; 	rm openjdk.tgz*; 		{ echo '#!/usr/bin/env bash'; 		echo 'set -Eeuo pipefail'; 		echo 'trust extract --overwrite --format=java-cacerts --filter=ca-anchors --purpose=server-auth "$JAVA_HOME/jre/lib/security/cacerts"'; 	} > /etc/ca-certificates/update.d/docker-openjdk; 	chmod +x /etc/ca-certificates/update.d/docker-openjdk; 	/etc/ca-certificates/update.d/docker-openjdk; 		find "$JAVA_HOME/lib" -name '*.so' -exec dirname '{}' ';' | sort -u > /etc/ld.so.conf.d/docker-openjdk.conf; 	ldconfig; javac -version; 	java -version
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

