FROM elixir:1.7


RUN apk add --update git && \
    rm -rf /var/cache/apk/*

RUN mix local.hex --force && \
    mix local.rebar --force &&\
    mix archive.install hex phx_new 1.4.10 --force &&\
    mix deps.get

RUN apk add --no-cache make gcc libc-dev argon2


RUN apt-get update && apt-get install -y \
    inotify-tools \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /bank_stone

EXPOSE 4000
