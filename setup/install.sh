yum -y update
yum -y install epel-repo epel-release
yum -y update
yum remove git
yum -y install  https://centos7.iuscommunity.org/ius-release.rpm
yum -y install ansible python-pip curl policycoreutils-python openssh-server openssh-clients git2u-all
pip install ncclient
pip install netmiko


hostnamectl set-hostname gitlab

cat <<EOF | tee /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
127.0.0.1 gitlab.local gitlab
EOF

firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
systemctl reload firewalld.service

yum install -y postfix
systemctl enable postfix.service
systemctl start postfix.service
firewall-cmd --permanent --add-service=smtp
firewall-cmd --permanent --add-service=pop3
firewall-cmd --permanent --add-service=imap
firewall-cmd --permanent --add-service=smtps
firewall-cmd --permanent --add-service=pop3s
firewall-cmd --permanent --add-service=imaps
firewall-cmd --reload

cd
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash

sudo EXTERNAL_URL="http://gitlab.local" yum install -y gitlab-ce

curl -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/rpm/gitlab-runner_amd64.rpm
rpm -Uvh gitlab-runner_amd64.rpm


