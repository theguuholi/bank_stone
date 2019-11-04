FROM elixir:1.7

RUN mix local.hex --force && \
    mix local.rebar --force &&\
    mix archive.install hex phx_new 1.4.10 --force

RUN apt-get update && apt-get install -y \
    inotify-tools \
 && rm -rf /var/lib/apt/lists/*

 WORKDIR /bank_stone

EXPOSE 4000
