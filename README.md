![Ubuntu](https://github.com/mentos1386/workspace/workflows/ubuntu/badge.svg)
![Fedora](https://github.com/mentos1386/workspace/workflows/fedora/badge.svg)
![Packages](https://github.com/mentos1386/workspace/workflows/packages/badge.svg)

my workspace as a docker container
==================================

- [Introduction](#introduction)
- [Clipboard](#clipboard)
- [References](#references)

# TODO:

- [x] Multiarch build
- [x] Github actions
- [ ] Add the tools i use
  - zsh, spaceship-prompt, git
- [ ] Add the configurations i have
  - zsh, git, nextcloud
- [ ] GUI using VNC?


# Introduction

[blink shell](https://blink.sh) is an excellent minimalistic SSH and mosh client
for apple mobile devices.

For some folks, like me that's a tool #1, I spent most of the time in terminal
(also I work mostly from the iPad pro).

In this repo, i'm trying to create a full development/living workspace inside docker containers.

One of the requirements is that docker image produced should work on arm-based devices as well as on amd64. To allow for same experiance if you are on RaspberryPi or on your VPS.

## Why so complex

First i planed to just create a Dockerfile and build it using buildx multiarch capabilities.
But i soon run in to issue that tools i use aren't available for ARM.
As a solution, i started compiling them myself which resulted in a bunch of Dockerfiles and
duplicated github actions. To solve this, i created "workspace" cli tool to manage this.

Yeah i know, oeverengineering. But i want to have a simple way of bumping and adding new packages.

# Clipboard

Paste from iPad to blink works out of the box, but in opposite it depends. If we
copy wrapped lines, usually they breaks. I don't mind apps with menus and
interfaces (i.e. `mc`, `tmux` with window splits, editors, etc.)

As for now, the perfect solution is to use OSC52 escape codes, these works well
with ssh and recent `mosh`.

# References

[vim-oscyank plugin](https://github.com/ojroques/vim-oscyank)

