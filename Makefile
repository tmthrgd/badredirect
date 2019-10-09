export GO111MODULE=on

.PHONY: all serve deploy docker-serve docker-stop

all:

serve:
	go run .

docker-serve:
	docker build -t badredirect-tmthrgd-dev-server -f Dockerfile .
	docker run -p 8090:8090 -e PORT=8090 -d badredirect-tmthrgd-dev-server

docker-stop:
	docker stop $(shell docker ps -f ancestor=badredirect-tmthrgd-dev-server --format "{{.ID}}")

deploy:
	gcloud --project badredirect-tmthrgd-dev builds submit --tag gcr.io/badredirect-tmthrgd-dev/server
	gcloud --project badredirect-tmthrgd-dev beta run deploy server --image gcr.io/badredirect-tmthrgd-dev/server