apk update -U && apk add build-base git

mkdir -p /go/src/github.com/drone/
cd /go/src/github.com/drone/ || exit 1

git clone https://github.com/drone/drone.git drone
cd drone || exit 1
git checkout v2.11.1

go install -tags "nolimit" ./cmd/drone-server
