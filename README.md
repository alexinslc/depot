# Depot - Modern Rails 8.1 E-Commerce Application

[![Testing](https://github.com/alexinslc/depot/actions/workflows/test.yml/badge.svg)](https://github.com/alexinslc/depot/actions/workflows/test.yml)
[![Linting](https://github.com/alexinslc/depot/actions/workflows/lint.yml/badge.svg)](https://github.com/alexinslc/depot/actions/workflows/lint.yml)
[![Security](https://github.com/alexinslc/depot/actions/workflows/security.yml/badge.svg)](https://github.com/alexinslc/depot/actions/workflows/security.yml)
[![Docker Build](https://github.com/alexinslc/depot/actions/workflows/docker.yml/badge.svg)](https://github.com/alexinslc/depot/actions/workflows/docker.yml)

A modern e-commerce application built with **Rails 8.1.0** and **Ruby 3.3.6**, showcasing the latest Rails 8 features including the complete "Solid" stack.

Originally based on the [Agile Web Development with Rails 7](https://pragprog.com/titles/rails7/agile-web-development-with-rails-7/) book by Sam Ruby, this project has been completely upgraded to Rails 8.1.0 with modern development practices, CI/CD, and containerization.

## ✨ Key Features

### Rails 8 "Solid" Stack (Zero Redis!)
- 🚀 **Solid Queue** - Database-backed background jobs
- 💾 **Solid Cache** - Database-backed caching  
- 🔌 **Solid Cable** - Database-backed WebSockets
- 🔐 **Rails 8 Authentication** - Modern session-based auth with rate limiting

### Modern Development Stack
- ✅ **Ruby 3.3.6** with YJIT enabled
- ✅ **Rails 8.1.0** with all latest features
- ✅ **Tailwind CSS 4.x** for styling
- ✅ **Hotwire** (Turbo + Stimulus) for interactivity
- ✅ **SQLite3** for database (production-ready with proper configuration)

### DevOps & Infrastructure
- 🐳 **Docker** support with multi-stage builds
- 🐳 **Docker Compose** for local development
- 🤖 **Complete CI/CD Pipeline** with GitHub Actions
- 🔒 **Security scanning** with Brakeman and Bundler Audit
- 📊 **Code quality** enforcement with RuboCop
- 🧪 **Automated testing** on every commit

## 📋 Requirements

- **Ruby**: 3.3.6
- **Rails**: 8.1.0
- **Node.js**: 18.x or later (for Tailwind CSS)
- **Docker & Docker Compose**: Latest (optional, for containerized development)

## 🚀 Getting Started

### Option 1: Native Development

1. **Install dependencies**
   ```bash
   bundle install
   ```

2. **Set up databases**
   ```bash
   bin/rails db:setup
   ```

3. **Run the development server**
   ```bash
   bin/dev
   ```
   
   Access at http://localhost:3000

### Option 2: Docker Development

1. **Start all services**
   ```bash
   docker compose up
   ```
   
   Access at http://localhost:3000

2. **Run commands in container**
   ```bash
   docker compose exec web bin/rails console
   docker compose exec web bin/rails test
   ```

## 🧪 Testing

Run the full test suite:
```bash
bin/rails test
```

Run specific test types:
```bash
bin/rails test:models
bin/rails test:controllers
bin/rails test:system
```

## 🔐 Authentication

The application includes Rails 8's new authentication system:

- **Session-based authentication** with secure, httponly cookies
- **Rate limiting** (10 attempts per 3 minutes)
- **Password reset** via email
- **Multi-session support** with session tracking

### Login
Visit `/session/new` to sign in.

### Test User
Check `test/fixtures/users.yml` for test credentials.

## 📦 Database Structure

The application uses SQLite3 with separate databases for isolation:

- `db/development.sqlite3` - Main application data
- `db/queue_development.sqlite3` - Solid Queue jobs
- `db/cache_production.sqlite3` - Solid Cache (production only)
- `db/cable_production.sqlite3` - Solid Cable (production only)

## 🏗️ Architecture

### Models
- **Product** - E-commerce products with validations
- **User** - Authenticated users with secure passwords
- **Session** - User sessions with IP and user agent tracking

### Controllers
- **StoreController** - Public storefront (unauthenticated)
- **ProductsController** - Product management (unauthenticated for demo)
- **SessionsController** - User authentication
- **PasswordsController** - Password reset flow

### Background Jobs
Background jobs are processed by **Solid Queue**:
```bash
bin/jobs  # Start job workers
```

## 🚢 Deployment

### Docker Production Build

```bash
docker build -t depot:latest .
docker run -p 3000:3000 \
  -e RAILS_ENV=production \
  -e SECRET_KEY_BASE=$(bin/rails secret) \
  depot:latest
```

### Production Considerations

1. **Database**: Consider PostgreSQL for high-traffic production use
2. **Assets**: Assets are precompiled in Docker image
3. **Background Jobs**: Run `bin/jobs` as a separate process
4. **Environment Variables**: Set `SECRET_KEY_BASE` securely
5. **HTTPS**: Use a reverse proxy (nginx, Caddy) for SSL

## 🔄 CI/CD Pipeline

Automated workflows run on every PR and push to main:

- **Testing** - Full test suite with minitest
- **Linting** - RuboCop style and quality checks
- **Security** - Brakeman and bundler-audit scans
- **Docker** - Build and publish images to GHCR

## 🛠️ Development Tools

### Code Quality
```bash
bundle exec rubocop                    # Run linter
bundle exec rubocop --auto-correct-all # Auto-fix issues
```

### Security Scanning
```bash
bundle exec brakeman --no-pager        # Rails security scan
bundle exec bundler-audit check        # Dependency vulnerabilities
```

### Database Management
```bash
bin/rails db:migrate                   # Run migrations
bin/rails db:rollback                  # Rollback last migration
bin/rails db:seed                      # Seed database
bin/rails db:reset                     # Reset database
```

## 📚 Rails 8 Features Used

This application demonstrates many Rails 8 features:

- ✅ **Solid Queue** - Background job processing without Redis
- ✅ **Solid Cache** - Database-backed caching
- ✅ **Solid Cable** - WebSocket pub/sub without Redis
- ✅ **Authentication Generator** - Secure session-based auth
- ✅ **Rate Limiting** - Built-in request throttling
- ✅ **Kamal 2** Ready - Modern deployment configuration
- ✅ **Propshaft** - Modern asset pipeline (via Sprockets for compatibility)
- ✅ **Tailwind CSS 4.x** - JIT compilation

## 🐛 Troubleshooting

### Tests Failing
```bash
bin/rails db:test:prepare
bin/rails test
```

### Port Already in Use
```bash
# Find and kill process on port 3000
lsof -ti:3000 | xargs kill -9
```

### Docker Issues
```bash
docker compose down -v  # Remove volumes
docker compose build    # Rebuild images
docker compose up       # Start fresh
```

## 📖 Documentation

- [SECURITY.md](SECURITY.md) - Security policies and practices
- [MIGRATION_PLAN.md](MIGRATION_PLAN.md) - Rails 8.1 upgrade journey

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Run tests (`bin/rails test`)
4. Run linter (`bundle exec rubocop`)
5. Commit changes (`git commit -m 'Add amazing feature'`)
6. Push to branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

All PRs are automatically tested by CI/CD pipeline.

## 📝 License

This project is available for educational purposes.

## 🙏 Acknowledgments

- Sam Ruby for the excellent [Agile Web Development with Rails](https://pragprog.com/titles/rails7/) book
- Chris Oliver for the [Learn Ruby on Rails for Beginners](https://gorails.com/start) course
- The Rails core team for Rails 8 and the amazing Solid* libraries
- 37signals for pioneering the Solid stack in production

---

**Built with ❤️ using Rails 8.1.0 and Ruby 3.3.6**