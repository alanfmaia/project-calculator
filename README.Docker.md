### Construindo e executando sua aplicação

Para iniciar sua aplicação, execute:
`docker compose up --build`.

Sua aplicação estará disponível em http://localhost:3000.

### Observação sobre Portas e Exposição

Embora o `Dockerfile` contenha a instrução `EXPOSE 3000`, isso serve apenas para documentação. Para que a aplicação seja acessível do seu navegador, você deve mapear as portas:

- **Via Docker Compose (Recomendado):** Já está configurado no arquivo `compose.yaml`. Basta usar `docker compose up`.
- **Via Docker Run:** Você precisa passar o parâmetro de porta explicitamente:
  `docker run -p 3000:3000 teste:latest`

### Implantando sua aplicação na nuvem

Primeiro, construa sua imagem, por exemplo: `docker build -t myapp .`.
Se a sua nuvem usa uma arquitetura de CPU diferente da sua máquina de desenvolvimento (por exemplo, você está em um Mac M1 e seu provedor de nuvem é amd64), você deve construir a imagem para essa plataforma:
`docker build --platform=linux/amd64 -t myapp .`.

Em seguida, envie-a para o seu registro (registry), por exemplo: `docker push meu-registro.com/myapp`.

Consulte a documentação de [primeiros passos](https://docs.docker.com/go/get-started-sharing/) do Docker para mais detalhes sobre construção e envio.

### Referências
* [Guia de Node.js do Docker](https://docs.docker.com/language/nodejs/)
