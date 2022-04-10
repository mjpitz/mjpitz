apt-get update && apt-get install -y ca-certificates lsb-release wget

RELEASE_NAME=$(lsb_release -c -s)

mkdir -p /etc/apt/keyrings
wget -O- https://rspamd.com/apt-stable/gpg.key | gpg --dearmor | tee /etc/apt/keyrings/rspamd.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rspamd.gpg] http://rspamd.com/apt-stable/ $RELEASE_NAME main" | tee /etc/apt/sources.list.d/rspamd.list
echo "deb-src [arch=amd64 signed-by=/etc/apt/keyrings/rspamd.gpg] http://rspamd.com/apt-stable/ $RELEASE_NAME main"  | tee -a /etc/apt/sources.list.d/rspamd.list
apt-get update && apt-get --no-install-recommends install rspamd
