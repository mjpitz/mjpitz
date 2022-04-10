curl https://rspamd.com/rpm-stable/centos-7/rspamd.repo > /etc/yum.repos.d/rspamd.repo
rpm --import https://rspamd.com/rpm-stable/gpg.key
yum update && yum install rspamd
