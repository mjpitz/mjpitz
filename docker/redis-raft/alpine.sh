apk update -U && apk add build-base git cmake

mkdir -p /redis/src
cd /redis/src || exit 1

## Redis

git clone --depth 1 https://github.com/redis/redis.git redis
cd redis || exit 1
git checkout 87131a5fa612c0d2b688fc65c722ebc95ae8f42a

make && make install
ls && cd ..

## RedisRaft

git clone --depth 1 https://github.com/RedisLabs/redisraft.git redisraft
cd redisraft || exit 1
git checkout 4e10fdd7af6c5f33ba7f8d876443ed4416eeea3f

mkdir build && cd build || exit 1
cmake .. && make
ls && cd ../..
