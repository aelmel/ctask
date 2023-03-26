# Extend from the official Elixir image
FROM elixir:1.14-alpine as build

RUN mkdir /app
WORKDIR /app

# install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

COPY priv priv
COPY lib lib
RUN mix compile
RUN mix release

FROM alpine:3.17 AS app
RUN apk add --no-cache bash openssl libgcc libstdc++ ncurses-libs

EXPOSE 4000
ENV MIX_ENV=prod

# prepare app directory
RUN mkdir /app
WORKDIR /app

# copy release to app container
COPY --from=build /app/_build/prod/rel/crafting_tasks .
# COPY entrypoint.sh .
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
CMD ["bash", "/app/bin/crafting_tasks", "start"]