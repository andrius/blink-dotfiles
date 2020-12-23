.PHONY: fedora ubuntu packages all

fedora:
	@docker buildx build --load -t env-fedora -f Dockerfile.fedora .

ubuntu:
	@docker buildx build --load -t env-ubuntu -f Dockerfile.ubuntu .

packages:
	@docker buildx build --load -t starship:0.47.0 -f packages/Dockerfile.starship packages/

all: packages fedora ubuntu

