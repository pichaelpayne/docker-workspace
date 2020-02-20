FROM fedora

ARG username

RUN dnf update -y && \
	dnf -y install tmux wget vim openssh-clients python3 git whois bind-utils nmap ntpdate unzip && \
	dnf -y groupinstall 'Development Tools' && \
	pip3 install boto3 awscli && \
	pip3 install --upgrade git+git://github.com/Nike-Inc/gimme-aws-creds.git && \
	ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime && \
	systemctl enable ntpdate.service 

RUN adduser -m $username && \
	usermod -aG wheel $username &&\
	echo "alias ll='ls -la'" >> /home/$username/.bashrc

ADD src/sudoers /etc/sudoers
ADD src/.okta_aws_login_config /home/$username/.okta_aws_login_config