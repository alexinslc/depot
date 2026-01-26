# CLAUDE.md - Depot

## What is this?
Depot is a modern e-commerce application built with Rails 8.1.0. Originally from "Agile Web Development with Rails 7" book, upgraded to Rails 8.1.0 with the complete "Solid" stack (no Redis needed).

## Tech Stack
- **Framework**: Rails 8.1.0
- **Ruby**: 3.3.6 (YJIT enabled)
- **Database**: SQLite3
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS 4.x
- **Background Jobs**: Solid Queue (database-backed)
- **Caching**: Solid Cache (database-backed)
- **WebSockets**: Solid Cable (database-backed)
- **Auth**: Rails 8 Authentication (session-based with rate limiting)

## Project Structure
```
depot/
├── app/
│   ├── controllers/
│   ├── models/
│   ├── views/
│   └── javascript/    # Stimulus controllers
├── config/            # Rails config
├── db/                # Migrations, schema, seeds
├── test/              # Rails tests
└── public/            # Static files
```

## Commands
```bash
bundle install        # Install gems
bin/rails server      # Dev server (port 3000)
bin/rails test        # Run test suite
bin/rails db:migrate  # Apply migrations
bin/rails db:seed     # Seed data
bin/rubocop           # Lint/format code
```

## Docker
```bash
docker compose up     # Start all services
```

## Code Conventions
- Follow Rails Way conventions
- RuboCop for code style (see .rubocop.yml)
- Hotwire for interactivity - minimal JavaScript
- Tailwind CSS for styling
- Use Rails testing framework
- No Redis - Solid stack is database-backed

## CI/CD
GitHub Actions for:
- Testing
- Linting (RuboCop)
- Security scanning (Brakeman, Bundler Audit)
- Docker builds
