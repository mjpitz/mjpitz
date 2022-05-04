apt-get update -y && env DEBIAN_FRONTEND=noninteractive apt-get install -yq build-essential git cmake

mkdir -p /redis/src
cd /redis/src || exit 1

git clone --depth 1 https://github.com/redis/redis.git redis
# checkout commit
cd redis || exit 1
make && make install
ls && cd ..

git clone --depth 1 https://github.com/RedisLabs/redisraft.git redisraft
# checkout commit
cd redisraft || exit 1
mkdir build && cd build || exit 1
cmake .. && make
ls && cd ../..
