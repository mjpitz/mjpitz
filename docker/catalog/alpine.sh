apk update -U && apk add build-base git

cd /catalog/ || exit 1

go install ./
