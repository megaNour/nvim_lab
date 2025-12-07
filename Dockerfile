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
    python3 python3-pip python3.12-venv \
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


RUN curl -sLo marksman --output-dir /usr/local/bin/ \
  https://github.com/artempyanykh/marksman/releases/download/2025-11-30/marksman-linux-arm64 \
&& chmod 755 /usr/local/bin/marksman

RUN curl -sLO https://ziglang.org/builds/zig-aarch64-linux-0.16.0-dev.1484+d0ba6642b.tar.xz \
&& tar -xf zig-aarch64-linux-0.16.0-dev.1484+d0ba6642b.tar.xz \
&& ln -s $PWD/zig-aarch64-linux-0.16.0-dev.1484+d0ba6642b/zig /usr/local/bin

RUN git clone https://github.com/zigtools/zls \
&& cd zls \
&& zig build -Doptimize=ReleaseSafe \
&& ln -s $PWD/zig-out/bin/zls /usr/local/bin

ARG USER=ubuntu
ARG HOME=/home/ubuntu

USER $USER
WORKDIR $HOME

RUN touch $HOME/.bashrc && curl https://get.volta.sh | bash \
&& bash -ic "volta install node@24"

COPY config/.editorconfig /home/$USER/

WORKDIR $HOME

ENV XDG_CONFIG_HOME=/home/$USER/.config
ENV XDG_CACHE_HOME=/home/$USER/.cache

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
