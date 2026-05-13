# 🧮 Project Calculator - Docker Suite

[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![NodeJS](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org/en/)

Este repositório contém uma calculadora web otimizada, pronta para ser executada em ambientes containerizados. Esta documentação fornece instruções detalhadas para construção, execução e deploy utilizando Docker.

---

## 🚀 Guia de Início Rápido

### Pré-requisitos

Certifique-se de ter instalado em sua máquina:
* [Docker Desktop](https://www.docker.com/products/docker-desktop/) ou Engine.
* [Docker Compose](https://docs.docker.com/compose/install/).

---

## 🛠️ Construção e Execução

### Opção 1: Docker Compose (Recomendado)

O Docker Compose gerencia o build e o mapeamento de portas automaticamente conforme definido no arquivo `compose.yaml`.

```bash
# Iniciar a aplicação em segundo plano
docker compose up -d --build
```

A aplicação estará disponível em: [http://localhost:3000](http://localhost:3000)

### Opção 2: Docker CLI

Se preferir utilizar comandos manuais do Docker:

1. **Construir a imagem:**
   ```bash
   docker build -t calculadora-app:latest .
   ```

2. **Executar o container:**
   ```bash
   # Mapeando para a porta padrão 3000
   docker run -d -p 3000:3000 --name calc-container calculadora-app:latest
   ```

---

## 🌐 Configuração de Portas

Por padrão, a aplicação interna escuta na porta `3000`. Você pode mapear essa porta para qualquer porta do seu computador host (como a `8080`) durante a execução.

**Exemplo para rodar na porta 8080:**
```bash
docker run -d -p 8080:3000 --name calc-8080 calculadora-app:latest
```
Acesse em: [http://localhost:8080](http://localhost:8080)

---

## 🏗️ Estrutura do Projeto Docker

* `Dockerfile`: Configuração de build multi-estágio para otimização de imagem (reduzindo o tamanho final e aumentando a segurança).
* `compose.yaml`: Orquestração simplificada para desenvolvimento local.
* `.dockerignore`: Garante que arquivos desnecessários (como `node_modules` locais) não inflem o contexto do build.

---

## 🔐 Segurança e Integridade

Esta imagem segue rigorosos padrões de segurança, sendo verificada contra vulnerabilidades e assinada digitalmente para garantir sua procedência.

### 🛡️ Verificação de Vulnerabilidades (Trivy)
A imagem é periodicamente escaneada utilizando o [Trivy](https://github.com/aquasecurity/trivy) para garantir que não existam CVEs críticas ou altas.

**Para realizar o scan manualmente:**
```bash
trivy image calculadora-app:latest
```

### ✍️ Assinatura Digital (Cosign)
Para garantir que a imagem não foi alterada, utilizamos o [Cosign](https://github.com/sigstore/cosign) (projeto Sigstore) para assinatura digital.

**1. Verificar a assinatura da imagem:**
```bash
cosign verify --key keys/cosign.pub seu-usuario/calculadora:latest
```

**2. Assinar uma nova imagem (apenas para mantenedores):**
```bash
cosign sign --key keys/cosign.key seu-usuario/calculadora:latest
```

---

## ☁️ Deploy e Cloud

### Construção Multi-Plataforma
Se o seu provedor de nuvem utiliza uma arquitetura diferente (ex: AWS EC2 x86_64 enquanto você desenvolve em Mac M1/M2 ARM64):

```bash
docker build --platform=linux/amd64 -t seu-usuario/calculadora:latest .
```

### Publicação (Push)
```bash
docker push seu-usuario/calculadora:latest
```

---

## 📝 Comandos Úteis

| Comando | Descrição |
| :--- | :--- |
| `docker ps` | Lista containers em execução |
| `docker logs -f <nome>` | Visualiza logs em tempo real |
| `docker compose down` | Para e remove os recursos do compose |
| `docker image prune` | Remove imagens não utilizadas para liberar espaço |

---

## 📖 Referências
* [Docker Documentation](https://docs.docker.com/)
* [Node.js Docker Best Practices](https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md)

---
*Mantido por [alanfmaia](https://github.com/alanfmaia)*
