# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv

FROM node:20.18 AS base

RUN npm i -g pnpm

# Reutilizamos a versão do node instalada acima
FROM base AS dependencies

# É importante ter uma pasta de trabalho
WORKDIR /usr/src/app

# Tudo daqui para baixo vai acontecer na /app
COPY package.json pnpm-lock.yaml ./ 

RUN pnpm install

# Fase de build
FROM base AS build

WORKDIR /usr/src/app

# Copia tudo de source para o container
COPY . .

# Copia de outro stage o diretorio node modules
COPY --from=dependencies /usr/src/app/node_modules ./node_modules

RUN pnpm build
RUN pnpm prune --prod

FROM cgr.dev/chainguard/node:latest AS deploy

USER 1000
WORKDIR /usr/src/app

COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json ./package.json

EXPOSE 3333

CMD ["dist/server.mjs"]