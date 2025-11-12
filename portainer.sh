mkdir -p ~/portainer-stack && cd ~/portainer-stack
cat << 'EOF' > docker-compose.yml
# PROMISES: ...
version: '3.8'
services:
  portainer:
    image: portainer/portainer-ce:lts
    container_name: portainer
    restart: unless-stopped
    ports:
      - "9443:9443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
volumes:
  portainer_data:
EOF
docker compose up -d
xdg-open https://localhost:9443