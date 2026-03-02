#!/bin/bash
set -euo pipefail

# Install Docker and Nginx
apt-get update
apt-get install -y docker.io nginx git certbot python3-certbot-nginx
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

# Wait for DNS propagation then get certificate
sleep 30
certbot --nginx -d ${domain_name} -d www.${domain_name} --non-interactive --agree-tos -m ${email} --redirect

# Auto-renew cron
echo "0 3 * * * certbot renew --quiet" | crontab -
