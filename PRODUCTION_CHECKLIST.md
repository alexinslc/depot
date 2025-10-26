# Production Deployment Checklist

Use this checklist before deploying to production to ensure everything is configured correctly.

## Pre-Deployment

### ☐ Environment Configuration
- [ ] Copy `.env.example` to `.kamal/secrets`
- [ ] Set `SECRET_KEY_BASE` (generate with `rails secret`)
- [ ] Set `RAILS_MASTER_KEY` (from `config/master.key`)
- [ ] Set `KAMAL_REGISTRY_PASSWORD` (GitHub Personal Access Token)
- [ ] Configure SMTP settings for email delivery
- [ ] Set production `HOST` domain
- [ ] Review all environment variables

### ☐ Server Setup
- [ ] Provision production server(s)
- [ ] Configure DNS (A/AAAA records pointing to server)
- [ ] Set up SSH key access
- [ ] Configure firewall (allow ports 80, 443, 22)
- [ ] Install Docker on server (or let Kamal do it)
- [ ] Verify server meets minimum requirements (1GB RAM, 10GB disk)

### ☐ Code Preparation
- [ ] Run full test suite (`bin/rails test`)
- [ ] Run security scans (`bundle exec brakeman`)
- [ ] Run linter (`bundle exec rubocop`)
- [ ] Update `config/deploy.yml` with server IPs
- [ ] Review `config/database.yml` for production settings
- [ ] Verify `.gitignore` excludes secrets
- [ ] Tag release version in Git

### ☐ Database
- [ ] Review migrations
- [ ] Test migrations on staging
- [ ] Plan for data backup
- [ ] Consider PostgreSQL for multi-server setup
- [ ] Verify SQLite WAL mode enabled (if using SQLite)

### ☐ Assets
- [ ] Precompile assets locally (test)
- [ ] Verify Tailwind CSS compilation
- [ ] Test asset serving
- [ ] Configure CDN if needed

### ☐ Security
- [ ] Enable Force SSL (`FORCE_SSL=true`)
- [ ] Configure rate limiting
- [ ] Review session settings
- [ ] Set secure cookie flags
- [ ] Configure CORS if API exists
- [ ] Review authentication settings

## Initial Deployment

### ☐ Kamal Setup
```bash
# First-time setup
bin/kamal setup

# This will:
# - Install Docker on server
# - Set up Thruster proxy
# - Request SSL certificate (Let's Encrypt)
# - Deploy application
# - Start job workers
```

### ☐ Post-Setup Verification
- [ ] Visit https://yourdomain.com
- [ ] Check SSL certificate
- [ ] Test health endpoint (`/health`)
- [ ] Test readiness endpoint (`/health/ready`)
- [ ] Verify application loads
- [ ] Check logs (`bin/kamal app logs`)

### ☐ Database Initialization
```bash
# Run on first deployment only
bin/kamal app exec 'bin/rails db:migrate'
bin/kamal app exec 'bin/rails db:seed'  # If needed
```

### ☐ Application Testing
- [ ] Test user authentication
- [ ] Test password reset email
- [ ] Test product CRUD
- [ ] Test background jobs
- [ ] Verify sessions work
- [ ] Check for JavaScript errors
- [ ] Test on mobile devices

## Monitoring Setup

### ☐ Health Checks
- [ ] Configure uptime monitoring (UptimeRobot, Pingdom)
- [ ] Monitor health endpoint
- [ ] Set up alert notifications
- [ ] Test alerting

### ☐ Error Tracking
- [ ] Set up Sentry/Honeybadger (optional)
- [ ] Configure error notifications
- [ ] Test error reporting
- [ ] Set up Slack/email alerts

### ☐ Performance Monitoring
- [ ] Set up APM (New Relic, Skylight) (optional)
- [ ] Monitor response times
- [ ] Track database queries
- [ ] Monitor memory usage

### ☐ Logging
- [ ] Verify logs are accessible (`bin/kamal app logs`)
- [ ] Set up log retention
- [ ] Configure log aggregation (optional)
- [ ] Test log searching

## Security Hardening

### ☐ SSL/TLS
- [ ] Verify HTTPS works
- [ ] Check SSL certificate validity
- [ ] Test SSL labs score (https://www.ssllabs.com/ssltest/)
- [ ] Configure HSTS headers

### ☐ Access Control
- [ ] Review who has server access
- [ ] Disable password auth (SSH keys only)
- [ ] Configure fail2ban (optional)
- [ ] Set up VPN for admin access (optional)

### ☐ Secrets Management
- [ ] Rotate secrets regularly
- [ ] Store secrets securely (1Password, AWS Secrets Manager)
- [ ] Never commit secrets to Git
- [ ] Use different secrets per environment

## Backup Strategy

### ☐ Database Backups
- [ ] Set up automated daily backups
- [ ] Test backup restoration
- [ ] Store backups off-server
- [ ] Set retention policy (30 days recommended)

### ☐ File Backups
- [ ] Back up uploaded files (Active Storage)
- [ ] Back up SQLite databases
- [ ] Test file restoration
- [ ] Automate backup process

## Performance Optimization

### ☐ Database
- [ ] Verify indexes exist
- [ ] Monitor query performance
- [ ] Enable query caching
- [ ] Consider read replicas (future)

### ☐ Caching
- [ ] Verify Solid Cache working
- [ ] Monitor cache hit rate
- [ ] Set appropriate cache TTLs
- [ ] Test cache invalidation

### ☐ Assets
- [ ] Enable compression (Thruster handles this)
- [ ] Set cache headers
- [ ] Consider CDN for static assets
- [ ] Optimize images

## Scaling Preparation

### ☐ Horizontal Scaling
- [ ] Document process for adding servers
- [ ] Plan for shared database
- [ ] Plan for shared file storage
- [ ] Update Kamal config for multi-server

### ☐ Vertical Scaling
- [ ] Monitor resource usage
- [ ] Plan for server upgrades
- [ ] Test with larger instance
- [ ] Document scaling procedures

## Documentation

### ☐ Update Documentation
- [ ] Document production URLs
- [ ] Document server IPs
- [ ] Document admin credentials (secure location)
- [ ] Document backup procedures
- [ ] Document rollback procedures
- [ ] Document monitoring setup

## Regular Deployment

For subsequent deployments:

```bash
# 1. Run tests locally
bin/rails test

# 2. Commit and push changes
git push

# 3. Deploy with Kamal
bin/kamal deploy

# 4. Run migrations if needed
bin/kamal app exec 'bin/rails db:migrate'

# 5. Verify deployment
curl https://yourdomain.com/health

# 6. Monitor logs
bin/kamal app logs -f
```

## Rollback Procedure

If something goes wrong:

```bash
# Quick rollback to previous version
bin/kamal rollback

# Or deploy specific version
bin/kamal deploy --version <version>

# Check container status
bin/kamal app details

# View logs
bin/kamal app logs
```

## Emergency Contacts

- Server provider support: _______________
- DNS provider support: _______________
- Development team: _______________
- On-call developer: _______________

## Post-Deployment

### ☐ Verification
- [ ] Test all critical features
- [ ] Monitor error rates
- [ ] Check performance metrics
- [ ] Verify background jobs running
- [ ] Monitor resource usage
- [ ] Check logs for errors

### ☐ Communication
- [ ] Notify team of deployment
- [ ] Update status page
- [ ] Monitor user feedback
- [ ] Be ready to rollback

## Maintenance

### Daily
- [ ] Monitor error rates
- [ ] Check application health
- [ ] Review logs for issues

### Weekly
- [ ] Review performance metrics
- [ ] Check disk space
- [ ] Verify backups working
- [ ] Update dependencies

### Monthly
- [ ] Rotate secrets
- [ ] Review security scans
- [ ] Update gems (`bundle update`)
- [ ] Performance audit

## Notes

- Keep this checklist updated
- Add project-specific items
- Review after each deployment
- Share with team

---

**Last Updated**: 2025-10-26  
**Next Review**: After each major deployment
