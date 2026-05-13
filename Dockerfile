# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7

# Estágio 1: Dependências
FROM node:current-alpine3.23 AS deps

WORKDIR /app

# Aproveita o cache do Docker para dependências
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev


# Estágio 2: Execução
FROM node:current-alpine3.23

ENV NODE_ENV production

WORKDIR /app

# Copia apenas o necessário do estágio de dependências
COPY --from=deps --chown=node:node /app/node_modules ./node_modules

# Copia o código fonte com permissões para o usuário node
COPY --chown=node:node . .

# Executa como usuário sem privilégios
USER node

EXPOSE 3000

# Verifica se a aplicação está respondendo corretamente
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/ || exit 1

CMD ["node", "server.js"]

