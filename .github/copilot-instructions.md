# GitHub Copilot Instructions for Depot

## Project Overview
Depot is a modern e-commerce application built with Rails 8.1.0 and Ruby 3.3.6. Features the Rails 8 "Solid" stack (Solid Queue, Solid Cache, Solid Cable) - no Redis required.

## Tech Stack
- **Framework**: Rails 8.1.0, Ruby 3.3.6 (YJIT enabled)
- **Database**: SQLite3
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS 4.x
- **Background Jobs**: Solid Queue
- **Caching**: Solid Cache
- **WebSockets**: Solid Cable
- **Auth**: Rails 8 Authentication (session-based)

## Project Structure
```
depot/
├── app/           # MVC components
├── config/        # Rails configuration
├── db/            # Migrations, seeds
├── test/          # Test files
├── bin/           # Executables
└── public/        # Static assets
```

## Commands
```bash
bundle install     # Install dependencies
bin/rails server   # Start dev server
bin/rails test     # Run tests
bin/rails db:migrate  # Run migrations
bin/rubocop        # Lint code
```

## Code Conventions
- Follow Rails conventions
- RuboCop for code style
- Hotwire for interactivity (minimal JS)
- Use Tailwind for styling
- Test with Rails testing framework
