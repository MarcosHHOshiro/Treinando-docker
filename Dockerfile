FROM node:20 AS build

WORKDIR /usr/src/app

# Copiar apenas arquivos essenciais para o build
COPY package.json yarn.lock ./
COPY .yarn ./.yarn
RUN yarn install

# Copiar o restante do código
COPY . .

# Construir o projeto
RUN yarn build

# Instalar dependências apenas para produção
RUN yarn install --production && yarn cache clean

FROM node:20-alpine3.19

WORKDIR /usr/src/app

# Copiar apenas arquivos necessários para produção
COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD ["yarn", "start:prod"]
