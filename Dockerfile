FROM elixir:1.17.2-otp-27

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN curl -sL https://deb.nodesource.com/setup_21.x | bash - \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs locales inotify-tools gcc g++ make imagemagick \
    && rm -rf /var/cache/apt \
    && mix local.hex --force \
    && mix local.rebar --force \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen

WORKDIR /workspace
