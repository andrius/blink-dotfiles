dotfiles for blink.sh env
=========================

<!-- MarkdownTOC autolink="true" uri_encoding="false" levels="1,2,3,4,5,6" GFM -->

- [Introduction](#introduction)
- [Clipboard](#clipboard)
  - [Disclamer](#disclamer)
- [Setup](#setup)
- [Development setup with docker](#development-setup-with-docker)
  - [Start and stop service](#start-and-stop-service)
  - [Access host from the blink](#access-host-from-the-blink)
- [References](#references)
- [Demo](#demo)

<!-- /MarkdownTOC -->

# Introduction

[blink shell](https://blink.sh) is an excellent minimalistic SSH and mosh client
for apple mobile devices.

For some folks, like me that's a tool #1, I spent most of the time in terminal
(also I work mostly from the iPad pro).

Here I share blink-related dotfiles and create a development repository.

Feel free to use, share and of course to contribute!

# Clipboard

Paste from iPad to blink works out of the box, but in opposite it depends. If we
copy wrapped lines, usually they breaks. I don't mind apps with menus and
interfaces (i.e. `mc`, `tmux` with window splits, editors, etc.)

As for now, the perfect solution is to use OSC52 escape codes, these works well
with ssh and recent `mosh`.

## Disclamer

In order to get clipboard setup working, we need recent software: tmux 3+, mosh
1.3+, vim 8+ or neovim 4.3+

Check your repository first! Usually it means that such apps should be compiled
or installed using [brew](https://brew.sh) (yes, it works with linux too!)

# Setup

Clone repository to the .dotfiles folder:

```shell
git clone http://github.com/andrius/blink-dotfiles ~/.dotfiles
```

Tmux setup:

```shell
ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
```

VIM or neovim setup:

```shell
mkdir -p ~/.config
ln -s ~/.dotfiles/nvim ~/.config/nvim
ln -s ~/.dotfiles/nvim/vimrc ~/.vimrc
git clone https://github.com/Shougo/dein.vim ~/.cache/vim/dein/repos/github.com/Shougo/dein.vim
# vim users: replace nvim by vim below
nvim -V1 -es -i NONE -N --noplugin -u "/home/${SSH_USER}/.config/nvim/config/vimrc" \
  -c "try | call dein#clear_state() | call dein#update() | finally | messages | qall! | endtry"
```

# Development setup with docker

It is possible to test stuff with docker. Given dockerfiles just contains `openssh-server`
and `mosh-server`, and minimal setup to get things working. It is possible to
test them directly from the blink shell

Supported docker services (and operating systems):

- alpine

  tmux, mosh and neovim installed with apk, clipboard does not work with mosh;

- debian

  tmux and mosh compiled, vim installed as a package. Clipboard works correctly;

- brew

  debian with homebrew installed. tmux, mosh and neovim installed with brew,
  everything works;

- ubuntu

  ubunut 20.10 with apt-get installed tmux, mosh and vim. Clipboard works
  correctly.

## Start and stop service

To start:

```shell
# assign alpine, debian, brew or ubuntu to the SERVICE
SERVICE=alpine && \
docker-compose build --force-rm --pull ${SERVICE} && \
docker-compose up -d ${SERVICE} && \
docker-compose logs -ft --tail=100 ${SERVICE}
```

To stop:

```shell
docker-compose rm --stop --force
```

## Access host from the blink

Each time when you build new docker image, SSH keys would be updated, so cleanup
known hosts file first:

```shell
rm ~/.ssh/known_hosts
```

SSH access:

```shell
ssh -oPort=22022 blink@host
```

mosh access:

```shell
mosh blink@host -P 22022 -p 22022
```

(if there is issue due to the busy UDP port, you might kill mosh-server first):

```shell
docker-compose exec alpine killall mosh-server
```

# References

[vim-oscyank plugin](https://github.com/ojroques/vim-oscyank)

# Demo

Screencast

[download link](./docs/sceencast.mp4)

![screencast](https://raw.githubusercontent.com/andrius/blink-dotfiles/main/docs/sceencast.mp4)
