# AGENTS.md - Depot

## Project Summary
Modern e-commerce app built with Rails 8.1.0 featuring the "Solid" stack (no Redis). Upgraded from the "Agile Web Development with Rails 7" book.

## Tech Stack
| Component | Technology |
|-----------|------------|
| Framework | Rails 8.1.0 |
| Ruby | 3.3.6 (YJIT) |
| Database | SQLite3 |
| Frontend | Hotwire (Turbo + Stimulus), Tailwind CSS 4.x |
| Background Jobs | Solid Queue |
| Caching | Solid Cache |
| WebSockets | Solid Cable |
| Auth | Rails 8 Authentication |

## Directory Structure
```
depot/
├── app/           # MVC components
├── config/        # Rails configuration
├── db/            # Migrations, seeds
├── test/          # Test suite
└── public/        # Static assets
```

## Commands
| Command | Purpose |
|---------|---------|
| `bundle install` | Install dependencies |
| `bin/rails server` | Start dev server |
| `bin/rails test` | Run tests |
| `bin/rails db:migrate` | Run migrations |
| `bin/rubocop` | Lint code |
| `docker compose up` | Docker development |

## Code Conventions
1. Follow Rails Way conventions
2. RuboCop for code style
3. Hotwire for interactivity (minimal JS)
4. Tailwind CSS for styling
5. Rails testing framework

## Rails 8 Features
- **Solid Queue**: Database-backed background jobs
- **Solid Cache**: Database-backed caching
- **Solid Cable**: Database-backed WebSockets
- **Auth Generator**: Session-based with rate limiting

## CI/CD
GitHub Actions: tests, linting, security, Docker builds
