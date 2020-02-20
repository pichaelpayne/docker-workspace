FROM fedora

ARG username

RUN dnf update -y && \
	dnf -y install tmux wget vim openssh-clients python3 git whois bind-utils nmap ntpdate && \
	dnf -y groupinstall 'Development Tools' && \
	pip3 install boto3 awscli && \
	pip3 install --upgrade git+git://github.com/Nike-Inc/gimme-aws-creds.git && \
	ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime && \
	systemctl enable ntpdate.service && \
	wget -P /usr/local/bin https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_linux_amd64.zip && \
	wget -P /usr/local/bin https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip && \
	unzip /usr/local/bin/terraform*
	
RUN adduser -m $username && \
	usermod -aG wheel $username &&\
	echo "alias ll='ls -la'" >> /home/$username/.bashrc

ADD src/sudoers /etc/sudoers
ADD src/.okta_aws_login_config /home/$username/.okta_aws_login_config