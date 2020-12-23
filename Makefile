.PHONY: fedora ubuntu packages package-kubectl package-starship all

fedora:
	@docker buildx build --load -t env-fedora -f Dockerfile.fedora .

ubuntu:
	@docker buildx build --load -t env-ubuntu -f Dockerfile.ubuntu .

package-starship:
	@docker buildx build --load -t starship -f packages/Dockerfile.starship packages/

package-kubectl:
	@docker buildx build --load -t kubectl -f packages/Dockerfile.kubectl packages/

packages: package-kubectl package-starship

all: packages fedora ubuntu

template:
	@go run ./main.go template package-action > .github/workflows/packages.yaml
	@go run ./main.go template ubuntu-action > .github/workflows/ubuntu.yaml
	@go run ./main.go template fedora-action > .github/workflows/fedora.yaml

