# 🛡️ Ultimate HomeLab: Security & Monitoring Hub

Este proyecto convierte una **Raspberry Pi** en el centro neurálgico de seguridad y monitorización de la red doméstica. No es solo un bloqueador de anuncios, es una infraestructura completa de **DNS Privado, Acceso Remoto Seguro (VPN) y Monitorización de Alta Disponibilidad**.

![Architecture](https://img.shields.io/badge/Raspberry_Pi-C51A4A?style=for-the-badge&logo=Raspberry%20Pi&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Pi-hole](https://img.shields.io/badge/Pi--hole-96060C?style=for-the-badge&logo=pi-hole&logoColor=white)
![Tailscale](https://img.shields.io/badge/Tailscale-1C1C1C?style=for-the-badge&logo=tailscale&logoColor=white)

## 🏗️ Arquitectura del Proyecto

El sistema se compone de 4 pilares fundamentales corriendo sobre Docker:

1.  **Privacidad DNS (Pi-hole + Unbound):**
    * Bloqueo de publicidad y rastreadores a nivel de red.
    * Resolución DNS recursiva propia (bypass de Google/ISP) para máxima privacidad.
2.  **Monitorización (Uptime Kuma):**
    * Vigilancia 24/7 de servicios internos y conectividad externa.
    * Alertas en tiempo real vía **Discord Webhooks** y **Healthchecks.io** (Heartbeat).
3.  **Acceso Remoto & VPN (Tailscale):**
    * Red overlay Zero-Trust para acceder a la LAN desde cualquier lugar.
    * Configuración de **Exit Node** para navegar seguro en redes públicas (hoteles, aeropuertos) usando el filtrado DNS de casa.
    * Bypass de CG-NAT (ideal para operadoras como Digi).
4.  **Mantenimiento Automático (Watchtower + Log2Ram):**
    * Actualización automática de contenedores.
    * Gestión de logs en RAM para extender la vida útil de la tarjeta SD.

## 🚀 Instalación Rápida

1.  Clona el repositorio:
    ```bash
    git clone [https://github.com/tu-usuario/tu-repo.git](https://github.com/tu-usuario/tu-repo.git)
    cd tu-repo
    ```
2.  Levanta la pila de contenedores:
    ```bash
    docker compose up -d
    ```
3.  Accede a los paneles:
    * **Pi-hole:** `http://<IP-RASPBERRY>/admin`
    * **Uptime Kuma:** `http://<IP-RASPBERRY>:3001`

## ⚙️ Configuraciones Adicionales

### VPN (Tailscale)
Para habilitar el acceso remoto y el bloqueo de anuncios fuera de casa:
1. Instalar Tailscale en el host: `curl -fsSL https://tailscale.com/install.sh | sh`
2. Anunciar como Exit Node: `sudo tailscale up --advertise-exit-node`
3. En el panel de Tailscale, configurar el DNS Global con la IP de la interfaz Tailscale de la Pi.

### Protección SD (Log2Ram)
Es vital instalar Log2Ram para evitar quemar la tarjeta SD con escrituras constantes de logs:
```bash
echo "deb [signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] [http://packages.azlux.fr/debian/](http://packages.azlux.fr/debian/) bookworm main" | sudo tee /etc/apt/sources.list.d/azlux.list
sudo apt install log2ram
```
