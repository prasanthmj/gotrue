.PHONY: all build deps image lint migrate test vet
CHECK_FILES?=$$(go list ./... | grep -v /vendor/)

help: ## Show this help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

all: lint vet test build ## Run the tests and build the binary.

build: ## Build the binary.
	go build -ldflags "-X github.com/netlify/gotrue/cmd.Version=`git rev-parse HEAD`"

deps: ## Install dependencies.
	@go get -u github.com/gobuffalo/pop/soda
	@go get -u golang.org/x/lint/golint
	@go mod download

image: ## Build the Docker image.
	docker build .

lint: ## Lint the code.
	golint $(CHECK_FILES)

migrate_dev: ## Run database migrations for development.
	hack/migrate.sh development

migrate_test: ## Run database migrations for test.
	hack/migrate.sh test

test: ## Run tests.
	go test -p 1 -v $(CHECK_FILES)

vet: # Vet the code
	go vet $(CHECK_FILES)

updb:
	docker run --name samplepg -e POSTGRES_PASSWORD=abcdefg -e POSTGRES_USER=svcuser -e POSTGRES_DB=appdb -d -p 5432:5432 postgres

runapp:
	go run main.go serve -c ./hack/test1.env

migratex:
	go run main.go migrate up -c ./hack/test1.env