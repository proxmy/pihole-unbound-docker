# Pi-hole + Unbound (Docker) 🛡️

Esta es una configuración completa para tener un servidor DNS privado y bloqueador de publicidad en toda la red local, usando una Raspberry Pi.

Incluye:
- **Pi-hole:** Panel de control y bloqueo de anuncios.
- **Unbound:** Resolver DNS recursivo propio (para no depender de Google ni de la operadora).

## 📋 Requisitos
- Raspberry Pi (cualquier modelo con Docker instalado).
- Docker y Docker Compose.

## 🚀 Instalación

1. Clona este repositorio o copia el archivo `docker-compose.yml`.
2. Levanta el contenedor:
   ```bash
   docker compose up -d
