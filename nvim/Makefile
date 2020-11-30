SHELL = /bin/bash
vim := $(if $(shell which nvim),nvim,$(shell which vim))
vim_version := '${shell $(vim) --version}'
XDG_CACHE_HOME ?= $(HOME)/.cache

default: install

install: create-dirs install-dein update-plugins

update: update-plugins

upgrade: update

create-dirs:
	@mkdir -vp "$(XDG_CACHE_HOME)/vim/"{backup,session,swap,tags,undo}

install-dein:
	@git clone https://github.com/Shougo/dein.vim ~/.cache/vim/dein/repos/github.com/Shougo/dein.vim

update-plugins:
	$(vim) -V1 -es -i NONE -N --noplugin -u config/vimrc \
		-c "try | call dein#clear_state() | call dein#update() | finally | messages | qall! | endtry"

uninstall:
	rm -rf "$(XDG_CACHE_HOME)/vim"

.PHONY: install create-dirs update-plugins uninstall
