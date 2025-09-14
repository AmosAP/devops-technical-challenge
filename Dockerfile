
# Etapa de build
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .

# Etapa de runtime
FROM node:18-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY --from=build /app /app

# Porta padrão do seu app
ENV PORT=3000
EXPOSE 3000

# Instala dependências do sistema (se necessário)
RUN apk add --no-cache curl

# Comando para iniciar sua aplicação
CMD ["node", "server.js"]
