BIN := awesome-go-orms
BUILD_LDFLAGS := "-s -w"
GOBIN ?= $(shell go env GOPATH)/bin
export GO111MODULE=on

.PHONY: all
all: clean build

.PHONY: deps
deps:
	go mod tidy

.PHONY: build
build:
	go build -ldflags=$(BUILD_LDFLAGS) -trimpath -o $(BIN)

.PHONY: test
test:
	go test -v -count=1 ./...

.PHONY: devel-deps
devel-deps: deps
	sh -c '\
      tmpdir=$$(mktemp -d); \
      cd $$tmpdir; \
      go get github.com/golangci/golangci-lint/cmd/golangci-lint@v1.36.0; \
      rm -rf $$tmpdir'

.PHONY: lint
lint: devel-deps
	go vet ./...
	golangci-lint run --config .golangci.yml ./...

.PHONY: clean
clean:
	rm -rf $(BIN)
	go clean
