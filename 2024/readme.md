# Aplicações realtime com Delphi e MQTT

### Executando uma instância do EMQX

O broker MQTT utilizado para testa apresentação foi o EMQX, um dos brokers mais populares e completos.
Para isso, vamos utilizar a [imagem oficial do EMQX no DockerHub].

#### Executando o container 

```sh
docker run -d --name emqx -p 18083:18083 -p 1883:1883 emqx:latest
```

### Verificando se o container está no ar

```sh
docker container ls
```

### Dashboard do EMQX

Acesse o [Dashboard do EMQX] com o usuário padrão `admin` e a senha `public`

![EMQX Dashboard](https://raw.githubusercontent.com/gabriellfabrega/Embarcadero-Conference/refs/heads/main/2024/emqx.png)
![EMQX Dashboard](https://raw.githubusercontent.com/gabriellfabrega/Embarcadero-Conference/refs/heads/main/2024/emqx2.png)


   [imagem oficial do EMQX no DockerHub]: <https://hub.docker.com/_/emqx>
   [Dashboard do EMQX]: <http://127.0.0.1:18083/>
