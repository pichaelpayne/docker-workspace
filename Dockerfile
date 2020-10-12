FROM fedora

ARG username

RUN dnf update -y && \
	dnf -y install tmux wget vim openssh-clients python3 nodejs git whois bind-utils nmap ntpdate unzip net-tools iputils openvpn && \
	dnf -y groupinstall 'Development Tools' && \
	pip3 install boto3 awscli && \
	pip3 install --upgrade git+git://github.com/Nike-Inc/gimme-aws-creds.git && \
	# npm install -g aws-cdk \
	ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime && \
	systemctl enable ntpdate.service && \
	curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm" && \
	yum install -y session-manager-plugin.rpm

RUN adduser -m $username && \
	usermod -aG wheel $username &&\
	echo "alias ll='ls -la'" >> /home/$username/.bashrc

ADD src/sudoers /etc/sudoers
ADD src/.okta_aws_login_config /home/$username/.okta_aws_login_config
