REGISTRY=ghcr.io/mentos1386
PROGRESS=plain


build:
	@docker buildx build --load -t ${REGISTRY}/workspace-ubuntu:edge -f Dockerfile.ubuntu .

build-package-starship:
	@docker buildx build --load -t ${REGISTRY}/starship:0.47.0 -f packages/Dockerfile.starship packages/

build-package-kubectl:
	@docker buildx build --load -t ${REGISTRY}/kubectl:1.20.0 -f packages/Dockerfile.kubectl packages/

build-package-glow:
	@docker buildx build --load -t ${REGISTRY}/glow:1.3.0 -f packages/Dockerfile.glow packages/

build-package-mosh:
	@docker buildx build --progress ${PROGRESS} --load -t ${REGISTRY}/mosh:master -f packages/Dockerfile.mosh packages/

build-packages: package-kubectl package-starship

template:
	@go run ./main.go template package-action > .github/workflows/packages.yaml
	@go run ./main.go template ubuntu-action > .github/workflows/ubuntu.yaml

pull:
	@docker pull ghcr.io/mentos1386/workspace-ubuntu:edge
	@docker pull ghcr.io/mentos1386/starship:0.47.0
	@docker pull ghcr.io/mentos1386/kubectl:1.20.0

run:
	@docker run -it --rm --workdir /home/tine --user tine ghcr.io/mentos1386/workspace-ubuntu:edge zsh

