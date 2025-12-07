FROM ubuntu:24.04

ENV debian_frontend=noninteractive

RUN apt update && apt install -y --no-install-recommends \
    cmake \
    ninja-build \
    gettext \
    git \
    curl \
    ripgrep \
    fd-find \
    lua5.1 \
    liblua5.1-dev \
    libunwind-dev \
    libbfd-dev \
    nodejs npm \
    python3 python3-pip \
    build-essential \
    ca-certificates \
    unzip \
    ncurses-term \
    locales \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN curl -sLO https://luarocks.org/releases/luarocks-3.12.2.tar.gz \
&& tar zxpf luarocks-3.12.2.tar.gz \
&& cd luarocks-3.12.2 \
&& ./configure \
&& make \
&& make install

RUN git clone --depth 1 --branch v0.11.5 https://github.com/neovim/neovim \
&& cd neovim \
&& make CMAKE_BUILD_TYPE=RelWithDebInfo \
&& make install \
&& ln -s /usr/local/bin/nvim /usr/local/bin/nv

RUN git clone https://github.com/LuaLS/lua-language-server \
&& cd lua-language-server \
&& chmod 744 ./make.sh \
&& ./make.sh \
&& ln -s $PWD/build/bin/lua-language-server /usr/local/bin

COPY config/.editorconfig /home/$USER/

ARG USER=ubuntu

USER $USER
WORKDIR /home/$USER

ENV XDG_CONFIG_HOME=/home/$USER/.config
ENV XDG_CACHE_HOME=/home/$USER/.cache

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
