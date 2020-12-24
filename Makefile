.PHONY: build-ubuntu
build-ubuntu:
	@docker buildx build --load -t env-ubuntu -f Dockerfile.ubuntu .

.PHONY: build-package-starship
build-package-starship:
	@docker buildx build --load -t starship -f packages/Dockerfile.starship packages/

.PHONY: build-package-kubectl
build-package-kubectl:
	@docker buildx build --load -t kubectl -f packages/Dockerfile.kubectl packages/

.PHONY: build-packages
build-packages: package-kubectl package-starship

build: packages ubuntu

.PHONY: template
template:
	@go run ./main.go template package-action > .github/workflows/packages.yaml
	@go run ./main.go template ubuntu-action > .github/workflows/ubuntu.yaml

pull:
	@docker pull ghcr.io/mentos1386/workspace-ubuntu:edge
	@docker pull ghcr.io/mentos1386/starship:0.47.0
	@docker pull ghcr.io/mentos1386/kubectl:1.20.0

run-ubuntu:
	@docker run -it --rm --workdir /home/tine --user tine ghcr.io/mentos1386/workspace-ubuntu:edge zsh

