#!/bin/bash
set -euo pipefail

# Install Docker and Nginx
apt-get update
apt-get install -y docker.io nginx git certbot python3-certbot-nginx dnsutils curl
systemctl enable docker
systemctl start docker

# Clone and build site
cd /opt
git clone https://github.com/deniz-hofmeister/hofmeister.dev.git
cd hofmeister.dev
docker build -t hofmeister-dev .
docker run -d --name hofmeister-dev --restart unless-stopped -p 8080:80 hofmeister-dev

# Configure Nginx reverse proxy
cat > /etc/nginx/sites-available/default <<'NGINX'
server {
    listen 80;
    server_name ${domain_name} www.${domain_name};

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
NGINX

systemctl restart nginx

# Wait for DNS to resolve to this instance before requesting certificate
MY_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
while true; do
  RESOLVED=$(dig +short ${domain_name} @8.8.8.8 | tail -1)
  if [ "$RESOLVED" = "$MY_IP" ]; then
    certbot --nginx -d ${domain_name} -d www.${domain_name} --non-interactive --agree-tos -m ${email} --redirect
    break
  fi
  sleep 30
done

# Auto-renew cron
echo "0 3 * * * certbot renew --quiet" | crontab -
