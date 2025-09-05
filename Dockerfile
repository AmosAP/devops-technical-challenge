# Dockerfile para Node.js + Express + Swagger
FROM node:22-alpine

# Diretório de trabalho
WORKDIR /app

# Copia arquivos de dependências
COPY package*.json ./

# Instala dependências
RUN npm install --production

# Copia o restante do código
COPY . .

# Expõe a porta do servidor
EXPOSE 3000

# Define variáveis de ambiente (pode ser sobrescrito no deploy)
ENV NODE_ENV=production

# Comando para iniciar o servidor
CMD ["node", "server.js"]
