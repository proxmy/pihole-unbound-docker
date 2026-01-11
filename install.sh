#!/bin/bash

# Colores para que se vea bonito
VERDE='\033[0;32m'
AZUL='\033[0;34m'
ROJO='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${AZUL}=================================================${NC}"
echo -e "${AZUL}   INSTALADOR AUTOMÁTICO: Pi-hole + Unbound      ${NC}"
echo -e "${AZUL}=================================================${NC}"

# 1. Comprobar si somos root
if [ "$EUID" -ne 0 ]; then
  echo -e "${ROJO}Por favor, ejecuta este script como root (usa sudo).${NC}"
  exit
fi

# 2. Actualizar el sistema (Raspberry Pi OS / Ubuntu / Debian)
echo -e "${VERDE}[+] Actualizando el sistema operativo... (Esto puede tardar)${NC}"
apt-get update && apt-get upgrade -y

# 3. Instalar Docker y Docker Compose si no existen
if ! command -v docker &> /dev/null; then
    echo -e "${VERDE}[+] Docker no detectado. Instalando Docker...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    # Añadir al usuario actual al grupo docker
    usermod -aG docker ${SUDO_USER:-$USER}
    echo -e "${VERDE}[+] Docker instalado correctamente.${NC}"
else
    echo -e "${VERDE}[+] Docker ya estaba instalado.${NC}"
fi

# 4. Preparar directorios
DIRECTORIO_INSTALL="/home/${SUDO_USER:-$USER}/pihole-unbound"
echo -e "${VERDE}[+] Creando estructura de carpetas en: $DIRECTORIO_INSTALL${NC}"

mkdir -p "$DIRECTORIO_INSTALL/unbound"
cd "$DIRECTORIO_INSTALL"

# 5. Crear archivo unbound.conf
echo -e "${VERDE}[+] Generando configuración de Unbound...${NC}"
cat <<EOF > unbound/unbound.conf
server:
    verbosity: 0
    interface: 0.0.0.0
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes
    do-ip6: no
    prefer-ip6: no
    harden-glue: yes
    harden-dnssec-stripped: yes
    use-caps-for-id: no
    edns-buffer-size: 1232
    prefetch: yes
    num-threads: 1
    so-rcvbuf: 1m
    access-control: 127.0.0.1/32 allow
    access-control: 192.168.0.0/16 allow
    access-control: 172.16.0.0/12 allow
    access-control: 10.0.0.0/8 allow
    hide-identity: yes
    hide-version: yes
EOF

# 6. Crear docker-compose.yml
# Nota: Incluye el fix de DNSMASQ_LISTENING: all para que funcione a la primera
echo -e "${VERDE}[+] Generando docker-compose.yml...${NC}"
cat <<EOF > docker-compose.yml
services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "80:80/tcp"
    environment:
      TZ: 'Europe/Madrid'
      DNSMASQ_LISTENING: all
      WEBPASSWORD: 'admin'
      PIHOLE_DNS_: '172.20.0.5#5335'
    volumes:
      - './etc-pihole:/etc/pihole'
      - './etc-dnsmasq.d:/etc/dnsmasq.d'
    restart: unless-stopped
    networks:
      private_network:
        ipv4_address: 172.20.0.2

  unbound:
    container_name: unbound
    image: mvance/unbound:latest
    volumes:
      - './unbound:/opt/unbound/etc/unbound'
    ports:
      - "5335:5335/tcp"
      - "5335:5335/udp"
    restart: unless-stopped
    networks:
      private_network:
        ipv4_address: 172.20.0.5

networks:
  private_network:
    ipam:
      driver: default
      config:
        - subnet: 172.20.0.0/24
EOF

# 7. Solucionar conflicto puerto 53 (común en Ubuntu/Raspi modernos)
echo -e "${VERDE}[+] Asegurando que el puerto 53 esté libre...${NC}"
systemctl stop systemd-resolved 2>/dev/null
systemctl disable systemd-resolved 2>/dev/null
# Edita resolv.conf para que la Pi tenga internet temporalmente si se queda sin DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# 8. Arrancar contenedores
echo -e "${VERDE}[+] Despegando contenedores... 🚀${NC}"
docker compose up -d

# 9. Mostrar resultado
IP_LOCAL=$(hostname -I | awk '{print $1}')
echo -e "${AZUL}=================================================${NC}"
echo -e "${AZUL}   ¡INSTALACIÓN COMPLETADA CON ÉXITO! 🎉         ${NC}"
echo -e "${AZUL}=================================================${NC}"
echo -e "Accede al panel aquí: http://$IP_LOCAL/admin"
echo -e "Contraseña:           admin"
echo -e ""
echo -e "${ROJO}IMPORTANTE:${NC} No olvides configurar tu Router con la DNS: $IP_LOCAL"
echo -e "${AZUL}=================================================${NC}"
