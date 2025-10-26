# Kamal 2 Deployment Guide

This application uses Kamal 2 for zero-downtime deployments with Thruster as the HTTP/2 proxy.

## Prerequisites

1. **Docker** installed on your local machine
2. **SSH access** to your production server(s)
3. **GitHub Container Registry** (GHCR) token with write access

## Initial Setup

### 1. Configure Secrets

Edit `.kamal/secrets` and set your secrets:

\`\`\`bash
# GitHub Container Registry password (use Personal Access Token)
KAMAL_REGISTRY_PASSWORD=<your_ghcr_token>

# Rails master key (from config/master.key or credentials)
RAILS_MASTER_KEY=<your_master_key>

# Rails secret key base (generate with: rails secret)
SECRET_KEY_BASE=<your_secret_key>
\`\`\`

### 2. Update Server Configuration

Edit `config/deploy.yml` and update:

\`\`\`yaml
servers:
  web:
    - 192.168.0.1  # Your server IP
  job:
    hosts:
      - 192.168.0.1  # Your server IP

proxy:
  host: yourdomain.com  # Your actual domain
\`\`\`

### 3. DNS Configuration

Point your domain to your server IP:
\`\`\`
A    yourdomain.com  -> your_server_ip
AAAA yourdomain.com  -> your_server_ipv6 (optional)
\`\`\`

## Deployment Commands

### First-Time Setup

\`\`\`bash
# Set up Kamal on the server (installs Docker, creates directories)
bin/kamal setup

# This will:
# - Install Docker on the server
# - Pull the Thruster proxy image
# - Set up SSL certificates (Let's Encrypt)
# - Start the application
\`\`\`

### Deploy Updates

\`\`\`bash
# Deploy new version
bin/kamal deploy

# This will:
# - Build Docker image locally
# - Push to GitHub Container Registry
# - Pull image on server
# - Start new containers
# - Run zero-downtime switchover
# - Remove old containers
\`\`\`

### Other Useful Commands

\`\`\`bash
# View application logs
bin/kamal app logs -f

# View job worker logs
bin/kamal app logs -f --roles job

# Run Rails console on server
bin/kamal app exec -i 'bin/rails console'

# Run database migrations
bin/kamal app exec 'bin/rails db:migrate'

# Restart the application
bin/kamal app restart

# Stop the application
bin/kamal app stop

# Start the application
bin/kamal app start

# View container status
bin/kamal app details

# SSH into server
bin/kamal app ssh

# View proxy (Thruster) logs
bin/kamal proxy logs -f

# Restart proxy
bin/kamal proxy restart

# Rollback to previous version
bin/kamal rollback
\`\`\`

## How It Works

### Thruster Proxy

Thruster acts as a reverse proxy in front of your Rails application:

- **HTTP/2 Support**: Modern protocol for better performance
- **Automatic HTTPS**: Uses Let's Encrypt for SSL certificates
- **Asset Caching**: Caches static assets efficiently
- **X-Sendfile**: Efficient file serving
- **Zero Configuration**: Works out of the box

### Zero-Downtime Deployments

1. Kamal builds new Docker image
2. Pushes to registry (GHCR)
3. Pulls image on server
4. Starts new containers alongside old ones
5. Runs health checks on new containers
6. Thruster switches traffic to new containers
7. Old containers are stopped and removed

### Health Checks

Kamal uses `/health` endpoint to verify application health:
- Checks every 10 seconds
- 7 attempts before marking unhealthy
- Traffic only goes to healthy containers

## Deployment Workflow

### Standard Deployment

\`\`\`bash
# 1. Make code changes locally
git commit -am "Add new feature"

# 2. Push to GitHub
git push

# 3. Deploy to production
bin/kamal deploy

# 4. Verify deployment
curl https://yourdomain.com/health
\`\`\`

### Database Migrations

\`\`\`bash
# Deploy with migrations
bin/kamal deploy
bin/kamal app exec 'bin/rails db:migrate'

# Or combine
bin/kamal deploy && bin/kamal app exec 'bin/rails db:migrate'
\`\`\`

### Rollback

If something goes wrong:

\`\`\`bash
# Rollback to previous version
bin/kamal rollback

# Or redeploy specific version
bin/kamal deploy --version <version>
\`\`\`

## Environment Variables

Kamal injects these environment variables:

- `RAILS_ENV=production`
- `RAILS_LOG_TO_STDOUT=true`
- `RAILS_SERVE_STATIC_FILES=true`
- `RAILS_MASTER_KEY` (from secrets)
- `SECRET_KEY_BASE` (from secrets)

## Volumes

Persistent storage is mounted:

- `/rails/storage` - Active Storage uploads
- `/rails/db` - SQLite databases

## Monitoring

### View Live Logs

\`\`\`bash
# Application logs
bin/kamal app logs -f

# Proxy logs
bin/kamal proxy logs -f

# Job worker logs
bin/kamal app logs -f --roles job
\`\`\`

### Container Status

\`\`\`bash
# Check running containers
bin/kamal app details

# Check system resources
bin/kamal app exec 'df -h'  # Disk space
bin/kamal app exec 'free -m'  # Memory
\`\`\`

## Troubleshooting

### Container Won't Start

\`\`\`bash
# Check logs
bin/kamal app logs

# SSH into server and check Docker
bin/kamal app ssh
docker ps -a
docker logs depot-web-latest
\`\`\`

### SSL Certificate Issues

\`\`\`bash
# Check proxy logs
bin/kamal proxy logs

# Restart proxy
bin/kamal proxy restart
\`\`\`

### Database Issues

\`\`\`bash
# Check database connectivity
bin/kamal app exec -i 'bin/rails dbconsole'

# Run migrations manually
bin/kamal app exec 'bin/rails db:migrate'
\`\`\`

### Registry Authentication

\`\`\`bash
# Verify secrets are set
cat .kamal/secrets

# Test registry login
docker login ghcr.io -u alexinslc
\`\`\`

## Best Practices

1. **Always test locally** before deploying
2. **Run tests** before deployment
3. **Use staging environment** for big changes
4. **Monitor logs** during deployment
5. **Have rollback plan** ready
6. **Backup database** before migrations
7. **Use version tags** for easy rollback

## Security

- `.kamal/secrets` is gitignored (contains sensitive data)
- Use GitHub Personal Access Token, not password
- Rotate secrets regularly
- Use SSH keys for server access
- Keep Docker and Thruster updated

## Multi-Server Deployment

For multiple servers:

\`\`\`yaml
servers:
  web:
    - 192.168.0.1
    - 192.168.0.2
    - 192.168.0.3
  job:
    hosts:
      - 192.168.0.4
\`\`\`

Kamal will deploy to all servers in parallel.

## References

- [Kamal Documentation](https://kamal-deploy.org)
- [Thruster GitHub](https://github.com/basecamp/thruster)
- [Rails Deployment Guide](https://guides.rubyonrails.org/deployment.html)
