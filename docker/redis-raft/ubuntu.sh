apt-get update -y && env DEBIAN_FRONTEND=noninteractive apt-get install -yq build-essential git cmake

mkdir -p /redis/src
cd /redis/src || exit 1

## RedisRaft

git clone --depth 1 https://github.com/RedisLabs/redisraft.git redisraft
cd redisraft || exit 1
git checkout 4e10fdd7af6c5f33ba7f8d876443ed4416eeea3f

mkdir build && cd build || exit 1
cmake .. && make
ls && cd ../..
