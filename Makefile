REGISTRY=ghcr.io/mentos1386
PROGRESS=plain

build:
	@docker buildx build --load -t ${REGISTRY}/workspace:edge -f Dockerfile .

build-package-starship:
	@docker buildx build --load -t ${REGISTRY}/starship:0.47.0 -f packages/Dockerfile.starship .

build-package-kubectl:
	@docker buildx build --load -t ${REGISTRY}/kubectl:1.20.0 -f packages/Dockerfile.kubectl .

build-package-mosh:
	@docker buildx build --progress ${PROGRESS} --load -t ${REGISTRY}/mosh:master -f packages/Dockerfile.mosh .

build-packages: build-package-kubectl build-package-starship build-package-mosh

template:
	@go run ./main.go template package-action > .github/workflows/packages.yaml
	@go run ./main.go template workspace-node-action > .github/workflows/workspace-node.yaml

pull-node:
	@docker pull ghcr.io/mentos1386/workspace-node:edge

run-node:
	@docker run -it --rm --workdir /home/tine --user tine ${REGISTRY}/workspace-node:edge zsh
