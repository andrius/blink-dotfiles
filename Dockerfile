# vim: set fenc=utf-8 ts=2 sw=2 sts=2 et ft=Dockerfile :
FROM alpine:3.12

LABEL maintainer="Tine <mentos1386> Jozelj <tine@tjo.space>"
LABEL org.opencontainers.image.source https://github.com/mentos1386/workspace

ARG SSH_USER="${SSH_USER:-tine}"

RUN apk --update --no-cache add bash

SHELL ["bash", "-c"]

RUN apk --update --no-cache add \
      git \
      mosh \
      neovim \
      openssh-server \
      tmux \
      zsh \
&&  adduser -D "${SSH_USER}" -s /bin/zsh \
&&  ssh-keygen -f   /etc/ssh/ssh_host_rsa_key     -N '' -t rsa     \
&&  ssh-keygen -f   /etc/ssh/ssh_host_dsa_key     -N '' -t dsa     \
&&  ssh-keygen -f   /etc/ssh/ssh_host_ecdsa_key   -N '' -t ecdsa   \
&&  ssh-keygen -f   /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519 \
&&  chown root:root /etc/ssh  \
&&  chmod 0600      /etc/ssh/* \
&&  mkdir -p        /root/.ssh \
&&  chmod 0700      /root/.ssh \
&&  rm -rf /var/cache/apk/* \
           /tmp/* \
           /var/tmp/*

# Configure SSH
RUN echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config \
&&  echo "PasswordAuthentication no" >> /etc/ssh/sshd_config \
&&  echo "UsePAM no" >> /etc/ssh/sshd_config \
&&  echo "X11Forwarding no" >> /etc/ssh/sshd_config

# install tools
COPY --from=ghcr.io/mentos1386/starship:0.47.0 /usr/local/bin/starship /usr/local/bin/starship
COPY --from=ghcr.io/mentos1386/kubectl:1.20.0 /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=ghcr.io/mentos1386/glow:1.3.0 /usr/local/bin/glow /usr/local/bin/glow
COPY --from=ghcr.io/mentos1386/mosh:master /usr/bin/mosh /usr/bin/mosh
COPY --from=ghcr.io/mentos1386/mosh:master /usr/bin/mosh-server /usr/bin/mosh-server
COPY --from=ghcr.io/mentos1386/mosh:master /usr/bin/mosh-client /usr/bin/mosh-client
# Golang
COPY --from=golang:1.15.6 --chown=${SSH_USER} /usr/local/go /home/${SSH_USER}/.go
ENV PATH=/home/${SSH_USER}/.go/bin:$PATH
# Rust
COPY --from=rust:1.48.0 --chown=${SSH_USER} /usr/local/cargo /home/${SSH_USER}/.cargo
COPY --from=rust:1.48.0 --chown=${SSH_USER} /usr/local/rustup /home/${SSH_USER}/.rustup
ENV CARGO_HOME=/home/${SSH_USER}/.cargo
ENV RUSTUP_HOME=/home/${SSH_USER}/.rustup
ENV PATH=/home/${SSH_USER}/.cargo/bin:$PATH
# Node
COPY --from=node:15.5.0 /usr/local/bin/node /usr/local/bin/node
# TODO: Add yarbn/npm/npx/yarnpkg??

# Create .dotfiles
COPY --chown=${SSH_USER}:${SSH_USER} dotfiles /home/${SSH_USER}/.dotfiles

# User Configuration
USER "${SSH_USER}"

# GIT
RUN ln -s /home/${SSH_USER}/.dotfiles/git/gitconfig /home/${SSH_USER}/.gitconfig
# ZSH
RUN ln -s /home/${SSH_USER}/.dotfiles/zsh/zshrc /home/${SSH_USER}/.zshrc
# TMUX
RUN ln -s /home/${SSH_USER}/.dotfiles/tmux/tmux.conf /home/${SSH_USER}/.tmux.conf
# VIM
RUN mkdir -p "/home/${SSH_USER}/.config" \
&&  ln -s "/home/${SSH_USER}/.dotfiles/nvim" "/home/${SSH_USER}/.config/nvim" \
&&  ln -s "/home/${SSH_USER}/.dotfiles/nvim/vimrc" "/home/${SSH_USER}/.vimrc" \
&&  git clone --depth 1 https://github.com/Shougo/dein.vim "/home/${SSH_USER}/.cache/vim/dein/repos/github.com/Shougo/dein.vim" \
&&  nvim -V1 -es -i NONE -N --noplugin -u "/home/${SSH_USER}/.config/nvim/config/vimrc" \
      -c "try | call dein#clear_state() | call dein#update() | finally | messages | qall! | endtry"
# SSH
RUN mkdir -p /home/${SSH_USER}/.ssh \
&&  ln -s /home/${SSH_USER}/.dotfiles/ssh/authorized_keys /home/${SSH_USER}/.ssh/authorized_keys

USER root
EXPOSE 22/tcp
EXPOSE 22022/udp
CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]

