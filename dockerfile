FROM elixir:1.15.7-alpine AS build

RUN apk add --no-cache build-base git openssh-client \
    && rm -rf /var/cache/apk/*

ARG mix_env="dev"
WORKDIR /app

RUN mix do local.hex --force, local.rebar --force

COPY mix.exs mix.lock ./
COPY config config
RUN --mount=type=ssh mix do deps.get, deps.compile

COPY priv priv
COPY test test
COPY lib lib
COPY .formatter.exs .formatter.exs
COPY .credo.exs .credo.exs
COPY start.sh start.sh

RUN MIX_ENV=$mix_env mix do compile, release

FROM alpine:3.16 AS app

RUN apk add --no-cache openssl ncurses-libs libstdc++ \
    && rm -rf /var/cache/apk/*

RUN apk add --no-cache nodejs npm \
    && rm -rf /var/cache/apk/*

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/$MIX_ENV/rel/rafflefy ./
COPY --from=build --chown=nobody:nobody /app/start.sh ./start.sh

ENV HOME=/app

CMD ["sh", "./start.sh"]
