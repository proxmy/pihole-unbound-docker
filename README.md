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
   ```
## ⚠️ Configuración Importante (El Truco)
Para que Pi-hole acepte peticiones de otros dispositivos cuando corre en Docker (evitando el error "Refusing query from non-local network"), es necesario ejecutar este comando una vez iniciado el contenedor:

Bash

docker exec -it pihole pihole -a -i all
O configurarlo vía web en: Settings > DNS > Interface Settings > Permit all origins.

## ⚙️ Configuración del Router
Para que funcione en toda la casa:

Entrar al router (normalmente 192.168.0.1 o 1.1).

Buscar configuración DHCP / LAN.

Establecer como DNS Primario la IP de la Raspberry (ej: 192.168.0.210).

Dejar el DNS Secundario vacío o 0.0.0.0.

## ✅ Resultados
Navegación sin publicidad.

Privacidad total (Google no ve tus peticiones DNS).


3.  Dale a **Commit changes**.
