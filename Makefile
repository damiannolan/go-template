VERSION := 0.0.1-SNAPSHOT

APP = go-template
DOCKER_REG = docker.io/patnolanireland
TAG = $(VERSION)
USER = $(shell whoami)

docker-build:
	docker build -t $(DOCKER_REG)/$(APP):$(TAG) .

docker-push:
	docker push $(DOCKER_REG)/$(APP):$(TAG)

docker-build-dev:
	docker build -t $(DOCKER_REG)/$(APP):$(USER) .

docker-push-dev:
	docker push $(DOCKER_REG)/$(APP):$(USER)
	
helm-deploy:
	helm upgrade --install $(APP) helm/$(APP)

helm-deploy-dev:
	helm upgrade --install $(APP) helm/$(APP) --set image.tag=$(USER)

test:
	go test ./... -coverprofile=coverage.out && go tool cover -func=coverage.out

.PHONY: \
		docker-build \
		docker-push \
		docker-build-dev \
		docker-push-dev \
		helm-deploy \
		helm-deploy-dev \
		test
