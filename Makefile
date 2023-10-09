all: index.html catalog.json

index.html: go.mod go.sum main.go grafana/grafana.go
	go run main.go -output html > index.html

catalog.json: go.mod go.sum main.go grafana/grafana.go
	go run main.go -output json > catalog.json
