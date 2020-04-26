.PHONY: help

# Shell that make should use
SHELL:=bash

# Ubuntu distro string
OS_VERSION_NAME := $(shell lsb_release -cs)

#HOSTNAME = $(shell hostname)
#HOSTNAME = localhost
Author := DavidRios #$(echo "David Rios Mora")
Version := $(shell date "+%Y%m%d%H%M")
GitCommit := $(shell git rev-parse HEAD)
LDFLAGS := "-s -w -X main.Version=$(Version) -X main.GitCommit=$(GitCommit)"
#LDFLAGS := "-s -w -X main.Version=$(Version) -X main.GitCommit=$(GitCommit)"
LDFLAGS := "-s -w -X main.Version=$(Version) -X main.GitCommit=$(GitCommit) -X main.Author=$(Author)"


help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ".:*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

#--tail-flags=--retry --follow=name
run:
run: ## Run application for a specific cluster
	#ifeq ($(origing cluster),undefined)
	#endif
	echo "cluster $(cluster)"
	AUTHOR=davidrios go run -ldflags $(LDFLAGS) cmd/main.go -conf=./config.yml --cluster=$(cluster)

prod:
prod: ## Run application for production servers
  cluster := api-prod

dev: run
dev: ## Run application for dev severs
  cluster := api-dev

mac:
mac: ## Compile for mac
	go build -ldflags $(LDFLAGS) -a -installsuffix cgo -o bin/traze-tail-mac *.go

linux:
linux: ## Compile for linux
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags $(LDFLAGS) -a -installsuffix cgo -o bin/traze-tail-linux *.go
	#CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags $(LDFLAGS) -a -installsuffix cgo -o bin/traze-tail-linux	*.go

windows:
windows: ## Compile for windows
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -ldflags $(LDFLAGS) -a -installsuffix cgo -o bin/traze-tail-win.exe *.go

#  goreleaser --snapshot --skip-publish --rm-dist
release:
release: ## Release a new version of application
	AUTHOR=$(Author) goreleaser --skip-validate --skip-publish
	#goreleaser --skip-validate --debug --skip-publish --rm-dist
	#goreleaser --skip-publish --rm-dist
	#goreleaser --snapshot --skip-publish --rm-dist

deploy-local:
deploy-local: ## dist local
	cp config.yml ~/.local/tail-cluster.yml
	sudo cp dist/cluster-ssh-tail_linux_amd64/cluster-ssh-tail /usr/local/bin/cluster-tail

clean:
clean: ## Cleasn
	rm -fr dist


