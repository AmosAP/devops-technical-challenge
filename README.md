# OpenWeather Proxy API

This project is a proxy REST API for OpenWeather, built with Node.js v22.18.0. It exposes four endpoints to fetch weather and air pollution data using the OpenWeather API.

## Stack

- **Node.js** v22.18.0
- **Express**
- **Axios**
- **Swagger UI**
- **js-yaml**
- **dotenv**

## Endpoints

| Endpoint                      | Method | Description                        |
|-------------------------------|--------|------------------------------------|
| `/weather/current`            | GET    | Current weather by city            |
| `/weather/forecast`           | GET    | 5-day forecast (3h intervals)      |
| `/weather/coordinates`        | GET    | Current weather by coordinates     |
| `/weather/air_pollution`      | GET    | Air quality by coordinates         |

## Setup

1. **Clone the repository**

   ```
   git clone <repo-url>
   cd teste-devops
   ```

2. **Install dependencies**

   ```
   npm install
   ```

3. **Set your OpenWeather API key**

   Create a `.env` file in the project root:

   ```
   OPENWEATHER_API_KEY=your_openweather_api_key
   PORT=3000
   ```

4. **Run the server**

   ```
   npm run dev
   ```

5. **Access Swagger documentation**

   Open [http://localhost:3000/docs](http://localhost:3000/docs) in your browser.

##

# DevOps Technical Challenge — CI/CD na AWS com ECS Fargate

📌 **Descrição do desafio**
Este projeto foi desenvolvido como parte de um desafio prático DevOps, com o objetivo de implementar uma pipeline CI/CD automatizada para deploy de uma aplicação na AWS. O desafio foi recebido em 20 de agosto de 2025, com prazo de 8 dias para entrega.

📁 **Repositório base**
Repositório original: icroptec/devops-technical-challenge

Fork pessoal: AmosAP/devops-technical-challenge

🎯 **Objetivos**
- Ambientes isolados: Criar dois ambientes distintos na AWS — dev e prod — com configurações independentes.
- Deploy por branch: Commits na branch dev devem acionar deploy no ambiente dev; commits na branch prod devem acionar deploy no ambiente prod.
- Variáveis de ambiente: A aplicação depende da variável OPENWEATHER_API_KEY, que deve ser configurável com valores diferentes para cada ambiente.

🔐 **Valor usado no desafio:**
OPENWEATHER_API_KEY=ffeac58c055a05f96936fdccf74e3c6d

🛠️ **Tecnologias utilizadas**
- AWS ECS Fargate — execução de contêineres sem gerenciar servidores
- Amazon ECR — armazenamento seguro de imagens Docker
- GitHub Actions — automação do pipeline CI/CD
- Application Load Balancer (ALB) — exposição pública dos serviços
- Docker — containerização da aplicação Node.js

🧱 **Arquitetura da solução**
GitHub → GitHub Actions → Amazon ECR → ECS Fargate (dev/prod) → ALB → URLs públicas
Cada push nas branches dev ou prod:
- Gera uma nova imagem Docker
- Faz o push para o ECR com tag específica (dev-<sha> ou prod-<sha>)
- Atualiza o serviço ECS correspondente via update-service
- Expõe a aplicação via Load Balancer

📦 **Containerização**
A aplicação foi containerizada com um Dockerfile otimizado:
- Usa node:18-alpine para build e runtime
- Instala dependências com npm ci
- Expõe a porta 3000
- Escuta dinamicamente a porta definida pelo ECS (process.env.PORT)
- Inclui o Swagger via /docs com base no arquivo swagger.yaml

⚙️ **Pipeline CI/CD**
O pipeline foi implementado com GitHub Actions:
- Arquivo: .github/workflows/deploy.yml
- Gatilho: push nas branches dev e prod
- Etapas:
   - Seleção de ambiente e definição de variáveis
   - Autenticação via OIDC com IAM Role
   - Build e push da imagem Docker para o ECR
   - Atualização do serviço ECS com nova imagem

🌐 **URLs públicas da aplicação**
| Ambiente | URL pública | Load Balancer ARN |
|----------|----------------------------------------------------------|--------------------------------------------------------------------------|
| Dev      | http://loaddev-208858725.us-east-1.elb.amazonaws.com     | arn:aws:elasticloadbalancing:us-east-1:059200471100:loadbalancer/app/loaddev/9346811533cd18f9 |
| Prod     | http://proload-958524693.us-east-1.elb.amazonaws.com     | (ARN não informado)                                                      |

Exemplos de endpoints:
- Swagger: /docs
- Clima atual: /weather/current?city=Lisbon

🧪 **Testes locais**
Para testar a aplicação localmente:
```bash
docker build -t local-weather-api .
docker run -p 3000:3000 -e OPENWEATHER_API_KEY=ffeac58c055a05f96936fdccf74e3c6d local-weather-api
```

✅ **Justificativa técnica**
- ECS Fargate: elimina a necessidade de gerenciar servidores, com escalabilidade automática.
- ECR: armazena imagens Docker com segurança e integração nativa ao IAM.
- GitHub Actions: permite automação completa do ciclo de deploy, com controle por branch.
- ALB: expõe os serviços de forma pública e segura, com health checks configuráveis.

📋 **Pré-requisitos para replicar**
- Conta AWS com permissões para ECS, ECR, IAM e ALB
- Docker instalado localmente (opcional)
- Repositório GitHub com branches dev e prod
- Role IAM com trust policy para GitHub OIDC