REGISTRY=ghcr.io/mentos1386
PROGRESS=plain


build:
	@docker buildx build --load -t ${REGISTRY}/workspace:edge -f Dockerfile .

build-package-starship:
	@docker buildx build --load -t ${REGISTRY}/starship:0.47.0 -f packages/Dockerfile.starship .

build-package-kubectl:
	@docker buildx build --load -t ${REGISTRY}/kubectl:1.20.0 -f packages/Dockerfile.kubectl .

build-package-glow:
	@docker buildx build --load -t ${REGISTRY}/glow:1.3.0 -f packages/Dockerfile.glow .

build-package-mosh:
	@docker buildx build --progress ${PROGRESS} --load -t ${REGISTRY}/mosh:master -f packages/Dockerfile.mosh .

build-packages: package-kubectl package-starship

template:
	@go run ./main.go template package-action > .github/workflows/packages.yaml
	@go run ./main.go template workspace-action > .github/workflows/workspace.yaml

pull:
	@docker pull ghcr.io/mentos1386/workspace:edge

run:
	@docker run -it --rm --workdir /home/tine --user tine ghcr.io/mentos1386/workspace:edge zsh

