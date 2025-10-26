# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2024-10-26

### 🎉 Major Rails 8.1 Upgrade

Complete migration from Rails 7 to Rails 8.1.0 with modern development practices.

### Added

#### Rails 8 "Solid" Stack
- **Solid Queue** - Database-backed background job processing (eliminates Redis dependency for jobs)
- **Solid Cache** - Database-backed caching system (eliminates Redis dependency for cache)
- **Solid Cable** - Database-backed WebSocket pub/sub (eliminates Redis dependency for Action Cable)
- **Rails 8 Authentication** - Modern session-based authentication with rate limiting and password reset

#### CI/CD Pipeline
- GitHub Actions workflow for automated testing
- RuboCop linting workflow with auto-corrections
- Brakeman security scanning workflow
- Bundler Audit for dependency vulnerability scanning
- Docker build and publish workflow
- Automated workflows run on all PRs and pushes

#### Containerization
- Multi-stage Dockerfile for production deployments
- Docker Compose for local development
- Separate databases for queue, cache, and cable
- Non-root user configuration for security
- Optimized build with layer caching

#### Security Features
- Rate limiting on authentication endpoints (10 attempts per 3 minutes)
- Session tracking with IP address and user agent
- Secure password reset tokens with 15-minute expiration
- Httponly cookies with same-site protection
- Multi-session support
- Security scanning with Brakeman and Bundler Audit

#### Documentation
- Comprehensive README.md with Rails 8 features
- SECURITY.md with security policies
- CONTRIBUTING.md with development guidelines
- MIGRATION_PLAN.md documenting upgrade journey
- Inline code documentation improvements

### Changed

#### Core Upgrades
- Upgraded Ruby from 3.3.0 to 3.3.6
- Upgraded Rails from 7.x to 8.1.0
- Updated all gems to latest compatible versions
- Modernized database configuration for multiple databases

#### Infrastructure
- Replaced Redis with Solid Queue for background jobs
- Replaced Redis with Solid Cache for caching (production)
- Replaced Redis with Solid Cable for WebSockets (production)
- Configured separate SQLite databases for isolation

#### Development Workflow
- Added RuboCop with Rails and Performance extensions
- Configured code quality enforcement
- Set up continuous integration
- Improved local development setup

### Fixed
- Removed missing `inter-font.css` asset reference causing test failures
- Fixed RuboCop offenses across codebase (118+ auto-fixes)
- Corrected authentication redirect paths
- Fixed password reset token implementation
- Updated test assertions for authentication

### Removed
- **Redis dependency** for background jobs (now using Solid Queue)
- **Redis dependency** for caching (now using Solid Cache in production)
- **Redis dependency** for Action Cable (now using Solid Cable in production)

### Security
- Added Brakeman for Rails security scanning
- Added bundler-audit for gem vulnerability checking
- Implemented rate limiting on sensitive endpoints
- Added secure session management
- Configured security headers

### Performance
- Multi-stage Docker builds for smaller images
- Build caching for faster CI/CD
- Bundler caching in workflows
- Asset precompilation in Docker
- Database-backed Solid stack for simpler architecture

## [1.0.0] - Previous

### Initial Implementation
- Rails 7.x application
- Product catalog management
- Store front interface
- SQLite database
- Basic test coverage

---

## Migration Notes

### Breaking Changes from 1.x to 2.0

1. **Redis Removal**: The application no longer requires Redis for any functionality
2. **Authentication Added**: New authentication system requires user accounts
3. **Database Structure**: Multiple SQLite databases for different concerns
4. **Environment Variables**: New environment variables for production deployment

### Upgrade Path

For existing deployments:

1. Update Ruby to 3.3.6
2. Update Rails to 8.1.0
3. Run migrations: `bin/rails db:migrate`
4. Install Solid gems: Already in Gemfile
5. Configure Solid services (see config files)
6. Remove Redis configuration (if any)
7. Update deployment scripts for new architecture

### Configuration Changes

- `config/database.yml` - Now includes separate databases for queue, cache, and cable
- `config/cable.yml` - Updated for Solid Cable
- `config/queue.yml` - New file for Solid Queue
- `config/cache.yml` - New file for Solid Cache
- `config/routes.rb` - Added authentication routes

## Future Roadmap

### Planned Features
- [ ] Shopping cart functionality
- [ ] Order management system
- [ ] Admin dashboard
- [ ] Payment integration
- [ ] Email notifications
- [ ] Product search
- [ ] User profiles

### Potential Improvements
- [ ] PostgreSQL support for production
- [ ] Kubernetes deployment configuration
- [ ] Advanced caching strategies
- [ ] API for mobile apps
- [ ] Real-time order tracking
- [ ] Analytics dashboard

---

**Legend:**
- `Added` for new features
- `Changed` for changes in existing functionality
- `Deprecated` for soon-to-be removed features
- `Removed` for now removed features
- `Fixed` for any bug fixes
- `Security` for vulnerability fixes
