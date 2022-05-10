apt-get update -y && env DEBIAN_FRONTEND=noninteractive apt-get install -yq build-essential git cmake

mkdir -p /redis/src
cd /redis/src || exit 1

## Redis

git clone --depth 1 https://github.com/redis/redis.git redis
cd redis || exit 1
git checkout ${IMAGE_VERSION}

make && make install
ls && cd ..
