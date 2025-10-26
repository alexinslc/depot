# Deployment Guide

This guide covers deploying the Depot application to production environments.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Environment Variables](#environment-variables)
- [Database Setup](#database-setup)
- [Docker Deployment](#docker-deployment)
- [Traditional Deployment](#traditional-deployment)
- [Background Jobs](#background-jobs)
- [Monitoring](#monitoring)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### System Requirements
- **OS**: Linux (Ubuntu 20.04+ recommended)
- **Ruby**: 3.3.6
- **Node.js**: 18.x or later
- **RAM**: Minimum 1GB, 2GB+ recommended
- **Disk**: 10GB+ available

### Required Services
- **Web Server**: Puma (included)
- **Reverse Proxy**: nginx or Caddy (recommended for SSL)
- **Database**: SQLite3 (included) or PostgreSQL (recommended for high-traffic)

### Optional Services
- **Email**: SMTP server for password reset emails
- **Monitoring**: Application monitoring service
- **Logging**: Centralized logging service

## Environment Variables

### Required Variables

```bash
# Rails Secret Key (generate with: bin/rails secret)
SECRET_KEY_BASE=your_secret_key_here

# Rails Environment
RAILS_ENV=production

# Database URL (if using PostgreSQL)
# DATABASE_URL=postgresql://username:password@localhost/depot_production
```

### Optional Variables

```bash
# Server Configuration
RAILS_MAX_THREADS=5
WEB_CONCURRENCY=2
PORT=3000

# Job Processing
JOB_CONCURRENCY=1

# Email Configuration (for password reset)
SMTP_ADDRESS=smtp.example.com
SMTP_PORT=587
SMTP_DOMAIN=example.com
SMTP_USERNAME=your_username
SMTP_PASSWORD=your_password
SMTP_AUTHENTICATION=plain
SMTP_ENABLE_STARTTLS_AUTO=true

# Asset Host (CDN)
ASSET_HOST=https://cdn.example.com

# Application URL
HOST=example.com
```

## Database Setup

### SQLite (Default)

The application uses multiple SQLite databases:

```bash
db/production.sqlite3        # Main application data
db/queue_production.sqlite3  # Solid Queue jobs
db/cache_production.sqlite3  # Solid Cache (if used)
db/cable_production.sqlite3  # Solid Cable (if used)
```

**Setup:**
```bash
RAILS_ENV=production bin/rails db:setup
```

### PostgreSQL (Recommended for Production)

1. **Install PostgreSQL**
   ```bash
   sudo apt-get install postgresql postgresql-contrib
   ```

2. **Create Database**
   ```bash
   sudo -u postgres createdb depot_production
   sudo -u postgres createuser -s depot
   ```

3. **Update database.yml**
   ```yaml
   production:
     adapter: postgresql
     database: depot_production
     username: depot
     password: <%= ENV['DATABASE_PASSWORD'] %>
     host: localhost
     pool: 5
   ```

4. **Run Migrations**
   ```bash
   RAILS_ENV=production bin/rails db:migrate
   ```

## Docker Deployment

### Build Image

```bash
docker build -t depot:latest .
```

### Run Container

```bash
docker run -d \
  --name depot \
  -p 3000:3000 \
  -e SECRET_KEY_BASE=$(openssl rand -hex 64) \
  -e RAILS_ENV=production \
  -v /path/to/data:/rails/storage \
  depot:latest
```

### Docker Compose Production

Create `docker-compose.prod.yml`:

```yaml
version: '3.8'

services:
  web:
    image: depot:latest
    ports:
      - "3000:3000"
    environment:
      - SECRET_KEY_BASE=${SECRET_KEY_BASE}
      - RAILS_ENV=production
      - DATABASE_URL=${DATABASE_URL}
    volumes:
      - ./storage:/rails/storage
      - ./db:/rails/db
    restart: unless-stopped

  jobs:
    image: depot:latest
    command: bin/jobs
    environment:
      - SECRET_KEY_BASE=${SECRET_KEY_BASE}
      - RAILS_ENV=production
      - DATABASE_URL=${DATABASE_URL}
    volumes:
      - ./db:/rails/db
    restart: unless-stopped
```

Run:
```bash
docker compose -f docker-compose.prod.yml up -d
```

## Traditional Deployment

### 1. Prepare Server

```bash
# Update system
sudo apt-get update && sudo apt-get upgrade

# Install Ruby (using rbenv)
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 3.3.6
rbenv global 3.3.6

# Install dependencies
sudo apt-get install -y build-essential libsqlite3-dev nodejs npm
```

### 2. Deploy Application

```bash
# Clone repository
git clone https://github.com/yourusername/depot.git
cd depot

# Install gems
bundle config set --local deployment true
bundle config set --local without 'development test'
bundle install

# Set up environment
export SECRET_KEY_BASE=$(bin/rails secret)
export RAILS_ENV=production

# Precompile assets
bin/rails assets:precompile

# Setup database
bin/rails db:setup

# Start server
bin/rails server -e production -p 3000
```

### 3. Process Management with Systemd

Create `/etc/systemd/system/depot-web.service`:

```ini
[Unit]
Description=Depot Rails Application
After=network.target

[Service]
Type=simple
User=deploy
WorkingDirectory=/home/deploy/depot
Environment=RAILS_ENV=production
Environment=SECRET_KEY_BASE=your_secret_key
ExecStart=/home/deploy/.rbenv/shims/bundle exec puma -C config/puma.rb
Restart=always

[Install]
WantedBy=multi-user.target
```

Create `/etc/systemd/system/depot-jobs.service`:

```ini
[Unit]
Description=Depot Background Jobs (Solid Queue)
After=network.target

[Service]
Type=simple
User=deploy
WorkingDirectory=/home/deploy/depot
Environment=RAILS_ENV=production
Environment=SECRET_KEY_BASE=your_secret_key
ExecStart=/home/deploy/.rbenv/shims/bundle exec bin/jobs
Restart=always

[Install]
WantedBy=multi-user.target
```

Enable and start services:
```bash
sudo systemctl enable depot-web depot-jobs
sudo systemctl start depot-web depot-jobs
```

### 4. Reverse Proxy with nginx

Create `/etc/nginx/sites-available/depot`:

```nginx
upstream depot {
  server localhost:3000;
}

server {
  listen 80;
  server_name example.com;

  root /home/deploy/depot/public;

  location / {
    proxy_pass http://depot;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }

  location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
  }
}
```

Enable site:
```bash
sudo ln -s /etc/nginx/sites-available/depot /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 5. SSL with Certbot

```bash
sudo apt-get install certbot python3-certbot-nginx
sudo certbot --nginx -d example.com
```

## Background Jobs

The application uses **Solid Queue** for background job processing.

### Start Job Workers

**Docker:**
```bash
docker compose exec web bin/jobs
```

**Native:**
```bash
RAILS_ENV=production bin/jobs
```

### Monitor Jobs

```bash
# Rails console
RAILS_ENV=production bin/rails console

# Check job status
SolidQueue::Job.count
SolidQueue::Job.where(status: 'pending').count
```

### Configuration

Edit `config/queue.yml`:

```yaml
production:
  dispatchers:
    - polling_interval: 1
      batch_size: 500
  workers:
    - queues: "*"
      threads: 3
      processes: 2
      polling_interval: 0.1
```

## Monitoring

### Application Health

Create a health check endpoint (`config/routes.rb`):

```ruby
get '/health', to: proc { [200, {}, ['OK']] }
```

### Log Monitoring

```bash
# Application logs
tail -f log/production.log

# System logs (systemd)
sudo journalctl -u depot-web -f
sudo journalctl -u depot-jobs -f
```

### Performance Monitoring

Consider integrating:
- **New Relic** - Application performance monitoring
- **Skylight** - Rails performance monitoring
- **Sentry** - Error tracking
- **Datadog** - Infrastructure monitoring

## Troubleshooting

### Application Won't Start

1. Check logs:
   ```bash
   tail -f log/production.log
   ```

2. Verify environment variables:
   ```bash
   echo $SECRET_KEY_BASE
   echo $RAILS_ENV
   ```

3. Check database connections:
   ```bash
   RAILS_ENV=production bin/rails db:migrate:status
   ```

### Assets Not Loading

1. Precompile assets:
   ```bash
   RAILS_ENV=production bin/rails assets:precompile
   ```

2. Check asset paths in logs

3. Verify nginx configuration

### Jobs Not Processing

1. Check job worker is running:
   ```bash
   ps aux | grep jobs
   ```

2. Monitor job queue:
   ```bash
   RAILS_ENV=production bin/rails console
   SolidQueue::Job.where(status: 'pending').count
   ```

3. Restart job workers:
   ```bash
   sudo systemctl restart depot-jobs
   ```

### Database Locked (SQLite)

If using SQLite and experiencing locks:

1. Consider PostgreSQL for production
2. Reduce concurrent connections
3. Use separate databases for different concerns (already configured)

### Memory Issues

1. Reduce worker threads in `config/puma.rb`
2. Reduce job concurrency in `config/queue.yml`
3. Add swap space
4. Upgrade server RAM

## Backup Strategy

### Database Backups

**SQLite:**
```bash
# Backup all databases
cp db/production.sqlite3 backups/production-$(date +%Y%m%d).sqlite3
cp db/queue_production.sqlite3 backups/queue-$(date +%Y%m%d).sqlite3
```

**PostgreSQL:**
```bash
pg_dump depot_production > backups/depot-$(date +%Y%m%d).sql
```

### Automated Backups

Add to crontab:
```bash
# Daily backup at 2 AM
0 2 * * * /home/deploy/depot/bin/backup.sh
```

## Security Checklist

- [ ] SSL/TLS enabled (HTTPS)
- [ ] Environment variables secured
- [ ] Database credentials protected
- [ ] SECRET_KEY_BASE is strong and unique
- [ ] Regular security updates applied
- [ ] Firewall configured properly
- [ ] SSH key-based authentication only
- [ ] Application logs monitored
- [ ] Regular backups configured
- [ ] Security scanning enabled

## Scaling Considerations

### Horizontal Scaling

- Use load balancer (nginx, HAProxy, AWS ALB)
- Shared database (PostgreSQL required)
- Shared storage for uploads (S3, etc.)
- Session store in database or Redis

### Vertical Scaling

- Increase server resources (CPU, RAM)
- Optimize database queries
- Add database indexes
- Enable query caching

## Support

For deployment issues:
1. Check application logs
2. Review this documentation
3. Check GitHub Issues
4. Open a new issue with deployment details

---

**Remember:** Always test deployment in a staging environment first!
